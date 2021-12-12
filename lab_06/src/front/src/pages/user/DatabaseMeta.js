import React, { useRef } from 'react';

import { Container } from 'react-bootstrap';

import BootstrapTable from 'react-bootstrap-table-next';

import { getDatabaseMeta, getDatabaseVersion } from '../../utils/requests';

export default function DatabaseMeta() {
    const lock = useRef(false);
    const [state, setState] = React.useState({
        error: null,
        msg: null,
        id: null,
        alertDialog: false,
        list: null,
        version: ""
    })

    React.useEffect(() => {
        lock.current = true;
        setState(state => ({
            ...state,
            busy: true
        }));

        const getDBMeta = () => {
            getDatabaseMeta()
                .then(data => {
                    setState(state => ({
                        ...state,
                        error: null,
                        list: data
                    }))
                })
                .finally(() => {
                    setState(state => ({
                        ...state,
                        busy: false
                    }))
                    lock.current = false;
                });
        }

        getDatabaseVersion()
            .then(data => {
                setState(state => ({
                    ...state,
                    error: null,
                    version: data.version
                }))
                getDBMeta()
            })
            .catch(error => {
                setState(state => ({
                    ...state,
                    error: "other",
                    msg: error.message
                }))
            })
    }, []);

    return (
        <Container style={{ "marginTop": "96px", "marginBottom": "20px" }}>
            {state.version &&
            <h3>{state.version}</h3>}
            {state.list && state.list.length >= 1 &&
                <BootstrapTable keyField='id' data={state.list} columns={
                Object.keys(state.list[0]).map((key) =>
                    ({dataField: key, text: key})
                )

                }/>
            }
        </Container>
    );
}
