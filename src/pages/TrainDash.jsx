import React, { useState, useEffect } from "react";
import Navbar from "../components/Navbar";
import { Typewriter } from "react-simple-typewriter";
import News from "../components/News";
import { useNavigate } from "react-router-dom";
import Datepicker from "react-tailwindcss-datepicker";
import Train from "./Train";
import { FaCode } from "react-icons/fa";
import SelectTrain from "../components/SelectTrain";

export default function TrainDash() {
  const navigate = useNavigate();
  const [source, setSource] = useState("");
  const [destination, setDestination] = useState("");
  const [value, setValue] = useState({
    startDate: null,
    endDate: null,
  });
  const handleValueChange = (newValue) => {
    console.log("newValue:", newValue);
    setValue(newValue);
  };

  // To set the source value from Select Train using a Callback to make API call
  const handleSelectSource = (value) => {
    setSource(value);
    console.log(value);
  };

  // To set the destination value from Select Train using a Callback to make API call
  const handleSelectDestination = (value) => {
    setDestination(value);
    console.log(value);
  };

  return (
    <div className="relative flex flex-col md:flex-row min-h-screen bg-gray-900 bg-auto pb-6 hide-scrollbar">
      <Navbar />

      <div className="flex flex-col mt-12 p-5 items-left h-screen mb-10 rounded-lg overflow-y-auto overflow-x-hidden sm:w-1/3 bg-gray-800 no-scrollbar">
        <div className="flex flex-row justify-between">
          <p className="mt-2 text-left text-6xl font-extrabold tracking-tight text-white sm:text-3xl">
            <Typewriter
              words={["Enter Details"]}
              cursor
              cursorStyle="."
              loop={2}
            />
          </p>
        </div>

        <ul role="list" className="mt-4">
          <div className="mb-4">
            <label htmlFor="email" className="flex mb-2 font-bold text-white">
              Departure Station
            </label>
            {/*<input
              type="email"
              id="email"
              className="border border-gray-400 p-2 w-full rounded-lg bg-blue-100 placeholder-black text-black"
              value={source}
              placeholder="Enter Departure Station"
              onChange={(e) => setSource(e.target.value)}
              />*/}
            <SelectTrain onSelect={handleSelectSource} />
          </div>

          <div className="mb-4">
            <label htmlFor="email" className="flex mb-2 font-bold text-white">
              Arrival Station
            </label>
            {/*<input
              type="email"
              id="email"
              className="border border-gray-400 p-2 w-full rounded-lg bg-blue-100 placeholder-black text-black"
              value={destination}
              placeholder="Enter Arrival Station"
              onChange={(e) => setDestination(e.target.value)}
              />*/}
            <SelectTrain onSelect={handleSelectDestination} />
          </div>

          <label htmlFor="email" className="flex mb-2 font-bold text-white">
            Select Departure Date
          </label>
          <div className="z-10 border-white border-2 rounded-lg">
            <Datepicker
              primaryColor={"blue"}
              useRange={false}
              asSingle={true}
              value={value}
              onChange={handleValueChange}
            />
          </div>
          <button
            className="hover:scale-105 w-full transition-transform duration-1000 bg-gradient-to-r  from-blue-600 to-blue-600 text-white font-bold p-3 mt-4 rounded-lg"
            onClick={() => {
              navigate("/Recommend");
            }}
          >
            SEARCH
          </button>
        </ul>
        <ul className="mt-4">
          <Train ticker={"CIPLA.NS"} />
        </ul>
      </div>

      <div className="mt-12 mx-2 flex-col justify-evenly sm:w-2/3">
        <div className="flex flex-row justify-evenly mt-4">
          {/** Where the top gainers and losers are*/}
        </div>

        <div className="flex flex-row justify-evenly  mt-2 mb-2 w-full">
          {/** Where nifty charts were */}
        </div>

        <div className="mx-2 mt-6 my-1 flex-grow overflow-y-auto overflow-x-hidden no-scrollbar rounded-2xl">
          <News />
        </div>
      </div>
    </div>
  );
}
