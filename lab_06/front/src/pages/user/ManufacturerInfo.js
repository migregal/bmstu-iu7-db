import React from 'react';

import { Container, Form, Row, Col, Button } from 'react-bootstrap';

import { AsyncTypeahead } from 'react-bootstrap-typeahead';

import BootstrapTable from 'react-bootstrap-table-next';

import { getManufacturerInfo, getManufacturerList } from '../../utils/requests';

export default function ManufacturerInfo() {
    const [state, setState] = React.useState({
        error: null,
        msg: null,
        id: null,
        manufacturer: "",
        isLoading: false,
        list: [],
        manufacturers: null
    })

    const searchForManufacturer = (query) => {
        setState(state => ({
            ...state,
            manufacturer: query,
            isLoading: true
        }));
        getManufacturerInfo(query)
            .then(data => {
                setState(state => ({
                    ...state,
                    list: data == null ? [] : data
                }))
            })
            .finally(()=> {
                setState(state => ({
                    ...state,
                    isLoading: false,
                }))
            });
    }

    const handleSearch = async () => {
        try {
            const data = await getManufacturerList(state.manufacturer)
            setState(state => ({
                ...state,
                manufacturers: data
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
                            <Form.Label>Choose manufacturer</Form.Label>
                            <AsyncTypeahead
                                inline
                                isLoading={state.isLoading}
                                labelKey={option => `${option.manufacturer}`}
                                onSearch={(query) => searchForManufacturer(query)}
                                options={state.list}
                                onChange={(value) => {
                                    setState(state => ({
                                        ...state,
                                        manufacturer: value[0].manufacturer
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
                {state.manufacturers && state.manufacturers.length >= 1 &&
                    <BootstrapTable keyField='id' data={state.manufacturers} columns={
                        Object.keys(state.manufacturers[0]).map((key) =>
                            ({ dataField: key, text: key })
                        )
                    } />
                }
            </Container>
        </div>
    );
}
