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
        body: JSON.stringify({ page:1, company: company_name, shop: shop_name }),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(response.status.toString())
            }

            return response.json();
        })
}