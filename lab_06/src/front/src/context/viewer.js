import React, { useCallback, useEffect, useRef, useState } from "react"

import { getUserCreds } from "../utils/creds";

const ViewerContext = React.createContext()

const Provider = ViewerContext.Provider

export const ProviderWrapper = ({ children }) => {
    const [viewer, setViewer] = useState(null)
    const [first, setFirst] = useState(true)
    const busy = useRef(false)

    const update = useCallback(async () => {
        if (busy.current)
            return

        busy.current = true

        const data = getUserCreds()

        setViewer(data)

        busy.current = false
        setFirst(false)
        return data
    }, [])

    useEffect(() => void update(), [update])

    if (first) {
        return null
    }

    return (
        <Provider
            value={{
                viewer,
                update,
            }}
        >
            {children}
        </Provider>
    )
}

export default ViewerContext
