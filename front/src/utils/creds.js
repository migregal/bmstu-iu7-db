const CREDS_KEY = "user-creds"

export const setUserCreds = creds =>
    sessionStorage.setItem(CREDS_KEY, JSON.stringify(creds))

export const getUserCreds = () =>
    JSON.parse(sessionStorage.getItem(CREDS_KEY))

export const clearUserCreds = () =>
    sessionStorage.removeItem(CREDS_KEY)
