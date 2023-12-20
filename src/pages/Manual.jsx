import React from "react";
import Navbar from "../components/Navbar";
import image1 from "/Users/ameet/SIH-2023/src/assets/landingChatbot.jpeg";
const Manual = () => {
  return (
    <div className="flex flex-col bg-zinc-200 h-max p-10">
      <Navbar />

      <p className="flex flex-col items-center justify-center h-max p-20 text-bold text-black text-xl">
        The User Manual For Navigating through the application is as follows:
      </p>
      <p className="flex flex-col items-left justify-center h-max text-black text-lg m-1">
        1. CHAT BOT:
      </p>
      <p className="flex flex-col items-left justify-center h-max text-grey-800 text-md m-1">
        Click on the button on the left on the home screen to Use the Virtual
        Assisstant Chat bot.
      </p>
      <img src={image1} alt="Chat bot landing image" className="w-4/6" />
    </div>
  );
};

export default Manual;
