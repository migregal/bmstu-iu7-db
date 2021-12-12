import {
    Switch,
    Route,
    Redirect
} from "react-router-dom";

import EmployeeInfo from './EmployeeInfo.js'
import DatabaseMeta from "./DatabaseMeta.js";
import ReviewStats from "./ReviewStats.js";
import ManufacturerInfo from "./ManufacturerInfo.js";

export default function User() {
    return (
        <Switch>
            <Route path="/admin/meta">
                <DatabaseMeta />
            </Route>
            <Route path="/reviews/stats">
                <ReviewStats />
            </Route>
            <Route path="/manufacturers/list">
                <ManufacturerInfo />
            </Route>
            <Route path="/">
                <EmployeeInfo />
            </Route>
            <Route>
                <Redirect to="/" />
            </Route>
        </Switch>
    );
}
