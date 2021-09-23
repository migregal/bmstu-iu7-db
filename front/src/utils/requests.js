export function getDatabaseMeta() {
    return fetch(process.env.REACT_APP_REQ_URL + "admin/meta/", {
        method: "POST",
        headers: {
            Authorization: null,
            'Content-Type': 'application/json;charset=utf-8',
        },
        cache: 'no-cache',
        keepalive: false,
        body: JSON.stringify({}),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(response.status.toString())
            }

            return response.json();
        })
}

export function getCompaniesList(company_name) {
    return fetch(process.env.REACT_APP_REQ_URL + "query/companies/", {
        method: "POST",
        headers: {
            Authorization: null,
            'Content-Type': 'application/json;charset=utf-8',
        },
        cache: 'no-cache',
        keepalive: false,
        body: JSON.stringify({company: company_name}),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(response.status.toString())
            }

            return response.json();
        })
}


export function getShopsList(company_name, shop_name) {
    return fetch(process.env.REACT_APP_REQ_URL + "query/shops/", {
        method: "POST",
        headers: {
            Authorization: null,
            'Content-Type': 'application/json;charset=utf-8',
        },
        cache: 'no-cache',
        keepalive: false,
        body: JSON.stringify({company: company_name, shop: shop_name}),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(response.status.toString())
            }

            return response.json();
        })
}

export function getEmployeesList(company_name, shop_name) {
    return fetch(process.env.REACT_APP_REQ_URL + "query/employees/", {
        method: "POST",
        headers: {
            Authorization: null,
            'Content-Type': 'application/json;charset=utf-8',
        },
        cache: 'no-cache',
        keepalive: false,
        body: JSON.stringify({ company: company_name, shop: shop_name }),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(response.status.toString())
            }

            return response.json();
        })
}

export function getReviewsCount(period, step, low, high) {
    return fetch(process.env.REACT_APP_REQ_URL + "query/reviews/count/", {
        method: "POST",
        headers: {
            Authorization: null,
            'Content-Type': 'application/json;charset=utf-8',
        },
        cache: 'no-cache',
        keepalive: false,
        body: JSON.stringify({
            period: period,
            step: step,
            low: low,
            high: high
        })
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(response.status.toString())
            }

            return response.json();
        })
}

export function getReviewsStats(period, step, low, high) {
    return fetch(process.env.REACT_APP_REQ_URL + "query/reviews/stats/", {
        method: "POST",
        headers: {
            Authorization: null,
            'Content-Type': 'application/json;charset=utf-8',
        },
        cache: 'no-cache',
        keepalive: false,
        body: JSON.stringify({
            period: period,
            step: step,
            low: low,
            high: high
        })
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(response.status.toString())
            }

            return response.json();
        })
}

export function raiseSalary(employee, delta) {
    return fetch(process.env.REACT_APP_REQ_URL + "query/employees/raise/", {
        method: "POST",
        headers: {
            Authorization: null,
            'Content-Type': 'application/json;charset=utf-8',
        },
        cache: 'no-cache',
        keepalive: false,
        body: JSON.stringify({
            employee: employee,
            delta: delta
        })
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(response.status.toString())
            }

            return response.json();
        })
}

export function getManufacturerInfo(manufacturer) {
    return fetch(process.env.REACT_APP_REQ_URL + "query/manufacturers/info/", {
        method: "POST",
        headers: {
            Authorization: null,
            'Content-Type': 'application/json;charset=utf-8',
        },
        cache: 'no-cache',
        keepalive: false,
        body: JSON.stringify({
            manufacturer: manufacturer
        })
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(response.status.toString())
            }

            return response.json();
        })
}

export function getManufacturerList(manufacturer) {
    return fetch(process.env.REACT_APP_REQ_URL + "query/manufacturers/", {
        method: "POST",
        headers: {
            Authorization: null,
            'Content-Type': 'application/json;charset=utf-8',
        },
        cache: 'no-cache',
        keepalive: false,
        body: JSON.stringify({
            manufacturer: manufacturer
        })
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(response.status.toString())
            }

            return response.json();
        })
}
