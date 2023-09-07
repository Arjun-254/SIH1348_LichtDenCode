import Landing from "./pages/Landing";

import {
  Routes,
  Route,
  useNavigationType,
  useLocation,
} from "react-router-dom";
import { BrowserRouter } from "react-router-dom";
import { Assistant } from "./pages/Assistant";
import  Map  from "./components/Map";

function App() {
  return (
    <div className="App">
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Landing />} />
          <Route path="/Assistant" element={<Assistant />} />
          <Route path="/Map" element={<Map />} />
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
