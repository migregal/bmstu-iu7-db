import { Container, Nav, Navbar, NavDropdown } from "react-bootstrap";

import { ProviderWrapper } from "./context/viewer"

import Pages from './pages'
import { BrowserRouter } from 'react-router-dom';

function App() {
  return (
    <div className="App">
      <Navbar bg="dark" expand="lg" variant="dark">
        <Container>
          <Navbar.Brand href="/">DB Course</Navbar.Brand>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse id="basic-navbar-nav">
            <Nav className="me-auto">
              <Nav.Link href="/">Home</Nav.Link>
              <NavDropdown title="Admin" id="basic-nav-dropdown">
                <NavDropdown.Item href="admin/meta/">Meta</NavDropdown.Item>
                {/* <NavDropdown.Item href="#action/3.2">Another action</NavDropdown.Item>
                <NavDropdown.Item href="#action/3.3">Something</NavDropdown.Item>
                <NavDropdown.Divider />
                <NavDropdown.Item href="#action/3.4">Separated link</NavDropdown.Item> */}
              </NavDropdown>
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>
      <BrowserRouter>
        <ProviderWrapper>
          <Pages />
        </ProviderWrapper>
      </BrowserRouter>
    </div>
  );
}

export default App;
