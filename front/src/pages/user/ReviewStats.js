import React, { useRef } from 'react';

import { Container } from 'react-bootstrap';

import { LineChart, Line, CartesianGrid, XAxis, YAxis, Tooltip, Legend, Label } from 'recharts';
import { getReviewsCount, getReviewsStats } from '../../utils/requests';

import useWindowDimensions from '../../hooks/useWindowDimensions';

export default function ReviewStats() {
    const { height, width } = useWindowDimensions();

    const lock = useRef(false);
    const [state, setState] = React.useState({
        error: null,
        msg: null,
        id: null,
        alertDialog: false,
        list: null,
        period: 'year',
        step: 'week',
        low: 4.0,
        high: 7.0
    })

    React.useEffect(() => {
        lock.current = true;
        setState(state => ({
            ...state,
            busy: true
        }));

        const getStats = () => {
            getReviewsStats(state.period, state.step, state.low, state.high)
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
        }

        getReviewsCount(state.period, state.step, state.low, state.high)
            .then(data => {
                setState(state => ({
                    ...state,
                    error: null,
                    total_count: data
                }))
                getStats()
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
        <Container style={{ "marginTop": "5vh", "marginBottom": "20px" }}>
            {state.total_count &&
            <h3>Total reviews count: {state.total_count}</h3>
            }
            {state.list &&
                <LineChart
                    width={0.8 * width} height={0.7 * height} data={state.list}
                    margin={{ top: 5, right: 20, bottom: 5, left: 0 }}>
                    <Legend verticalAlign="top" height={36} />
                    <Line name={"Positive (avg rating > " + state.high + ")"}
                        type="monotone" dataKey="positive" stroke="#0A0" />
                    <Line name="Neutral" type="monotone" dataKey="neutral" stroke="#AAA" />
                    <Line name={"Negative (avg rating < " + state.low + ")"}
                        type="monotone" dataKey="negative" stroke="#A00" />
                    <CartesianGrid stroke="#ccc" strokeDasharray="5 5" />
                    <XAxis dataKey="date">
                    <Label value={state.step} position="left" offset={10} />
                    </XAxis>
                    <YAxis/>
                    <Tooltip />
                </LineChart>
            }

        </Container>
    );
}
