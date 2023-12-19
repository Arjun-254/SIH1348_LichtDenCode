from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By 
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time


import json
import re



def extract_text_and_links(html_string):
    clean_text = []

    train_data1 = {
        "train_name": [],
        "train_no": [],
        "total_votes": [],
        "cleanliness": [],
        "punctuality": [],
        "food": [],
        "ticket": [],
        "safety": [],
    }

    train_data2 = {
        "Type": [],
        "Zone": [],
        "From": [],
        "PFfrom": [],
        "Dep": [],
        "AvgDelay": [],
        "To": [],
        "PFto": [],
        "Arr": [],
    }

    # Find all occurrences of text inside <div> tags
    matches = re.findall(r'<div.*?>(.*?)</div>', html_string, re.DOTALL)

    # Append each match to the clean_text list
    clean_text.extend(matches)
    # Remove unnecessary elements
    clean_text = clean_text[20:]

    name_pattern = r'title1="([^"]*)"'
    lengths = []
    votes_pattern = r'\((\d+) votes\)'
    votes_patter2 = r'\((\d+)\)'
    for i in range(0, len(clean_text)):
        if clean_text[i] == '':
            lengths.append(i)
    j=0
    while j<len(lengths) and j<5:  # Adjusted the loop range
        the_rest = []  # Moved inside the loop to reset for each segment
        for i in range(lengths[j], lengths[j + 1], 1):
            if "title1" in clean_text[i]:
                train_data1["train_name"].append(re.search(name_pattern, clean_text[i]).group(1))
                train_data1["train_no"].append(clean_text[i][-5:])
            elif "votes" in clean_text[i]:
                train_data1["total_votes"].append(re.search(votes_pattern,clean_text[i]).group(1))
            elif "cleanliness" in clean_text[i]:
                train_data1["cleanliness"].append(re.search(votes_patter2,clean_text[i]).group(1))
            elif "punctuality" in clean_text[i]:
                train_data1["punctuality"].append(re.search(votes_patter2,clean_text[i]).group(1))
            elif "food" in clean_text[i]:
                train_data1["food"].append(re.search(votes_patter2,clean_text[i]).group(1))
            elif "ticket" in clean_text[i]:
                train_data1["ticket"].append(re.search(votes_patter2,clean_text[i]).group(1))
            elif "safety" in clean_text[i]:
                train_data1["safety"].append(re.search(votes_patter2,clean_text[i]).group(1))
            else:
                if len(clean_text[i]) <= 6:
                    the_rest.append(clean_text[i])
        j += 1
        
        # Check if the_rest list has enough elements before accessing them
        if len(the_rest) >= len(train_data2):
            k = 1
            for keys in train_data2.keys():
                train_data2[keys].append(the_rest[k])
                k += 1
    print(provide_cost())
    return train_data1, train_data2


def perform_search(station_1, station_2):


    from_station = driver.find_element(By.XPATH, '//input[@placeholder="from station"]')
    from_station.clear()
    from_station.send_keys(station_1 + Keys.DOWN + Keys.ENTER)
    time.sleep(2)
    driver.find_element(By.XPATH, '//div[@class="list showslow"]/table/tbody/tr').click()
    
    

    to_station = driver.find_element(By.XPATH, '//input[@placeholder="to station"]')
    to_station.clear()
    to_station.send_keys(station_2 + Keys.DOWN+ Keys.ENTER)
    time.sleep(1)
    driver.find_element(By.XPATH, '//div[@class="list showslow"]').click()

    # Get the HTML content of the div with class "srhres newbg inline alt"
    driver.find_element(By.XPATH, '//div[@id="SrhDiv"]').click()
    try:
        div_content = driver.find_element(By.XPATH, "//div[@class ='srhres newbg inline alt']").get_attribute("outerHTML")
    except:
        return "No Trains Found"
    trian_data1,train_data2 = extract_text_and_links(div_content)
    return trian_data1,train_data2
    # print(text_list)
    time.sleep(10)
    driver.quit()


