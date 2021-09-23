import React, { useRef } from 'react';

import { Container } from 'react-bootstrap';

import { LineChart, Line, CartesianGrid, XAxis, YAxis, Tooltip, Legend } from 'recharts';
import { getReviewsStats } from '../../utils/requests';

import useWindowDimensions from '../../hooks/useWindowDimensions';

export default function ReviewStats() {
    const { height, width } = useWindowDimensions();

    const lock = useRef(false);
    const [state, setState] = React.useState({
        error: null,
        msg: null,
        id: null,
        alertDialog: false,
        list: null
    })

    React.useEffect(() => {
        lock.current = true;
        setState(state => ({
            ...state,
            busy: true
        }));

        getReviewsStats()
            .then(data => {
                setState(state => ({
                    ...state,
                    error: null,
                    list: data
                }))
            })
            .catch(error => {
                setState(state => ({
                    ...state,
                    error: "other",
                    msg: error.message
                }))
            })
            .finally(() => {
                setState(state => ({
                    ...state,
                    busy: false
                }))
                lock.current = false;
            });
    }, []);

    return (
        <Container style={{ "marginTop": "96px", "marginBottom": "20px" }}>
            {state.list &&
                <LineChart
                    cx={0.5 * width}
                    width={0.8 * width} height={0.7 * height} data={state.list}
                    margin={{ top: 5, right: 20, bottom: 5, left: 0 }}>
                    <Legend verticalAlign="top" height={36} />
                    <Line name="Positive (avg rating > 7)"  type="monotone" dataKey="positive" stroke="#0A0" />
                    <Line name="Neutral" type="monotone" dataKey="neutral" stroke="#AAA" />
                    <Line name="Negative (avg rating < 3)"  type="monotone" dataKey="negative" stroke="#A00" />
                    <CartesianGrid stroke="#ccc" strokeDasharray="5 5" />
                    <XAxis dataKey="date" />
                    <YAxis />
                    <Tooltip />
                </LineChart>
            }

        </Container>
    );
}
