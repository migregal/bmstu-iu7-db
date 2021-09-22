import React from 'react';

import { Container, Form, Row, Col, Button } from 'react-bootstrap';

import { AsyncTypeahead } from 'react-bootstrap-typeahead';

import BootstrapTable from 'react-bootstrap-table-next';

import { getCompaniesList, getEmployeesList, getShopsList } from '../../utils/requests';

export default function EmployeeInfo() {
    const [state, setState] = React.useState({
        error: null,
        msg: null,
        id: null,
        company: "",
        shop: "",
        isLoading: false,
        list: [],
        employees: null
    })

    const searchForCompany = (query) => {
        setState(state => ({
            ...state,
            company: query,
            isLoading: true
        }));
        getCompaniesList(query)
            .then(data => {
                setState(state => ({
                    ...state,
                    isLoading: false,
                    list: data == null ? [] : data
                }))
            });
    }

    const searchForShop = (query) => {
        setState(state => ({
            ...state,
            isLoading: true,
            shop: query
        }));
        getShopsList(state.company, query)
            .then(data => {
                setState(state => ({
                    ...state,
                    isLoading: false,
                    list: data == null ? [] : data
                }))
            });
    }

    const handleSearch = async () => {
        try {
            const data = await getEmployeesList(state.company, state.shop)
            setState(state => ({
                ...state,
                employees: data
            }))
        } catch (e) {

        }
    }

    return (
        <div>
            <Container style={{ "marginTop": "96px", "marginBottom": "20px" }} >
                <Row className="g-2">
                    <Col md>
                        <Form.Group className="mb-3" controlId="exampleForm.ControlInput1">
                            <Form.Label>Choose company</Form.Label>
                            <AsyncTypeahead
                                inline
                                isLoading={state.isLoading}
                                labelKey={option => `${option.company}`}
                                onSearch={(query) => searchForCompany(query)}
                                options={state.list}
                                onChange={(value) => {
                                    setState(state => ({
                                        ...state,
                                        company: value[0].company
                                    }));
                                }}
                            />
                        </Form.Group>
                    </Col>
                    <Col md>
                        <Form.Group inline className="mb-3" controlId="exampleForm.ControlInput1">
                            <Form.Label>Choose shop</Form.Label>
                            <AsyncTypeahead
                                isLoading={state.isLoading}
                                labelKey={option => `${option.name}`}
                                onSearch={(query) => searchForShop(query)}
                                options={state.list}
                                onChange={(value) => {
                                    setState(state => ({
                                        ...state,
                                        shop: value[0].name
                                    }));
                                }}
                            />
                        </Form.Group>
                    </Col>
                </Row>
                <div style={{ display: 'flex', justifyContent: 'right' }}>
                    <Button
                        variant="success"
                        disabled={state.isLoading}
                        onClick={!state.isLoading ? handleSearch : null}>
                        {state.isLoading ? 'Loading…' : 'Click to load'}
                    </Button>
                </div>
            </Container>
            <Container>
                {state.employees && state.employees.length >= 1 &&
                    <BootstrapTable keyField='id' data={state.employees} columns={
                        Object.keys(state.employees[0]).map((key) =>
                            ({ dataField: key, text: key })
                        )

                    } />
                }
            </Container>
        </div>
    );
}
