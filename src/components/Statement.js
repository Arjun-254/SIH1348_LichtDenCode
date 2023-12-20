import React from "react";
import Threemodel from "./Threemodel";
import { Typewriter } from "react-simple-typewriter";
import { useNavigate } from "react-router-dom";

export default function Statement() {
  const navigate = useNavigate();
  return (
    <div className="overflow-hidden py-6 sm:py-18 ">
      <div className="mx-auto max-w-7xl px-10 lg:px-14">
        <div className="mx-auto grid max-w-2xl grid-cols-1 gap-y-16 sm:gap-y-20 lg:mx-0 lg:max-w-none lg:grid-cols-2 ">
          <div className="lg:pl-12 h-screen flex items-center justify-center pb-44">
            <div className="lg:max-w-lg">
              <h2 className="md:text-xl text-2xl font-bold leading-7 text-gray-700">
                Your personal travel companion
              </h2>
              <p className="md:text-9xl font-bold flex justify-center items-center tracking-tight bg-gradient-to-r from-blue-400 to-blue-700 bg-clip-text text-transparent text-9xl">
                Railway Mitra
              </p>
              <dl className="mt-4 max-w-9xl space-y-8 text-base leading-7 text-slate-200 lg:max-w-none">
                <p className="md:text-xl font-bold flex  tracking-tight bg-gradient-to-r from-gray-500 to-gray-900 bg-clip-text text-transparent text-xl">
                  <Typewriter
                    words={["Official AI companion of Indian Railways"]}
                    cursor
                    cursorStyle="."
                    loop={0}
                  />
                </p>
              </dl>
              <div className="flex mt-6 gap-x-4">
                <button
                  className=" animate-bounce flex justify-center items-center text-sm font-semibold leading-6 text-gray-200 py-3 px-12 bg-blue-600 hover:bg-blue-700 rounded-md transition-all duration-150 ease-in-out border-2  border-blue-600"
                  onClick={() => {
                    navigate("/Assistant");
                  }}
                >
                  Try our AI Travel Assistant
                </button>
                <button
                  className=" animate-bounce flex justify-center items-center text-sm font-semibold leading-6 text-gray-200 py-3 px-12 bg-blue-600 hover:bg-blue-700 rounded-md transition-all duration-150 ease-in-out border-2  border-blue-600"
                  onClick={() => {
                    navigate("/Dashboard");
                  }}
                >
                  Open Admin Dashboard
                </button>
                <button
                  className=" animate-bounce flex justify-center items-center text-sm font-semibold leading-6 text-gray-200 py-3 px-12 bg-blue-600 hover:bg-blue-700 rounded-md transition-all duration-150 ease-in-out border-2  border-blue-600"
                  onClick={() => {
                    navigate("/Translate");
                  }}
                >
                  Translator
                </button>
              </div>
            </div>
          </div>
          <Threemodel />
        </div>
      </div>
    </div>
  );
}
