import React, { useState, useEffect } from "react";
import Navbar from "../components/Navbar";
import { Typewriter } from "react-simple-typewriter";
import { useNavigate } from "react-router-dom";
import SelectTrain from "../components/SelectTrain";
import Datepicker from "react-tailwindcss-datepicker";

export default function TrainDash() {
  const navigate = useNavigate();
  const [source, setSource] = useState("");
  const [destination, setDestination] = useState("");

  const train_data1 = {
    train_name: ["Express Train 1", "Express Train 2" /* ... */],
    train_no: ["123", "456" /* ... */],
  };

  const train_data2 = {
    Dep: ["10:00 AM", "11:30 AM" /* ... */],
    PFfrom: ["Platform 1", "Platform 2" /* ... */],
  };

  // Combine the data into an array of objects
  const trainData = train_data1["train_name"].map((_, index) => ({
    trainNumber: train_data1["train_no"][index],
    trainName: train_data1["train_name"][index],
    platformNumber: train_data2["PFfrom"][index],
    trainTime: train_data2["Dep"][index],
  }));
  console.log(trainData);
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

  // Function to handle the announcement
  const handleIVRS = async (train) => {
    try {
      const response = await fetch("endpoint/make_call", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          // Add any additional headers as needed
        },
        body: JSON.stringify({
          train_name: train.trainName,
          train_no: train.trainNumber,
          platform_number: train.platformNumber,
          departure_time: train.trainTime,
        }),
      });

      if (response.ok) {
        // Handle success, e.g., show a success message
        console.log("Announcement successful");
      } else {
        // Handle error, e.g., show an error message
        console.error("Announcement failed");
      }
    } catch (error) {
      console.error("Error:", error);
    }
  };

  const handleSMS = async (train) => {
    try {
      const response = await fetch("endpoint/make_SMS", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          // Add any additional headers as needed
        },
        body: JSON.stringify({
          train_name: train.trainName,
          train_no: train.trainNumber,
          platform_number: train.platformNumber,
          departure_time: train.trainTime,
        }),
      });

      if (response.ok) {
        // Handle success, e.g., show a success message
        console.log("Announcement successful");
      } else {
        // Handle error, e.g., show an error message
        console.error("Announcement failed");
      }
    } catch (error) {
      console.error("Error:", error);
    }
  };

  const handleAnnouncement = (train) => {
    try {
      // Create a formatted string with train information
      const announcementString = `${train.trainName} (${train.trainNumber}) departing from ${train.platformNumber} at ${train.trainTime}`;

      // Navigate to Translateinfo component with the announcement string as props
      navigate("/Translate", {
        state: { announcement: announcementString },
      });
    } catch (error) {
      console.error("Error:", error);
    }
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
            <SelectTrain onSelect={handleSelectSource} />
          </div>
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
      </div>

      <div className=" mt-14 py-2 flex-col justify-center items-center sm:w-3/5 mx-auto">
        <ul role="list" class="divide-y divide-gray-100">
          {trainData.map((train, index) => (
            <li key={index} className="flex justify-between gap-x-6 py-5">
              <div className="flex min-w-0">
                <div className="min-w-0 flex-auto">
                  <h className="text-lg font-bold leading-6 text-gray-200">
                    {train.trainNumber}
                  </h>
                  <p className="text-2xl font-semibold text-white">
                    {train.trainName}
                  </p>
                  <p className="mt-1 truncate text-lg leading-5 text-gray-500">
                    {train.platformNumber}
                  </p>
                </div>
              </div>

              <div className="flex justify-evenly items-center gap-x-4 border-white border-2 h-10 rounded-lg p-2">
                <p className="text-2xl font-semibold text-white">
                  {train.trainTime}
                </p>
              </div>

              <div className="flex justify-evenly items-center gap-x-4">
                <button
                  className="py-3 px-2 text-white font-semibold bg-blue-500 rounded-xl"
                  onClick={() => handleAnnouncement(train)}
                >
                  Announcement
                </button>
                <button
                  className="py-3 px-2 text-white font-semibold bg-yellow-500 rounded-xl"
                  onClick={() => handleSMS(train)}
                >
                  Send SMS
                </button>
                <button
                  className="py-3 px-2 text-white font-semibold bg-green-500 rounded-xl"
                  onClick={() => handleIVRS(train)}
                >
                  IVRS (call)
                </button>
              </div>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}
