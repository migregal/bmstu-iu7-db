import React from "react"
import ViewerContext from "../context/viewer";

import User from "./user"

export default function Pages() {
  const { viewer } = React.useContext(ViewerContext)

  // Here should be an auth check
  // viewer
  //     ? <User />
  //     : <Guest />
  return (<User />)
}
