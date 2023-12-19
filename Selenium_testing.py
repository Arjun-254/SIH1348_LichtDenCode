from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By 
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

service = Service(executable_path="chromedriver.exe")
driver = webdriver.Chrome(service=service)  

driver.get("https://indiarailinfo.com/")

import re

def extract_text_and_links(html_string):
    # Remove <div> tags
    clean_text = []

# Find all occurrences of text inside <div> tags
    matches = re.findall(r'<div.*?>(.*?)</div>', html_string, re.DOTALL)

    # Append each match to the clean_text list
    clean_text.extend(matches)

    #remove blubber
    clean_text=clean_text[20:]

    #information per train is 30 lines
    print(clean_text[0])

    return clean_text


def perform_search(station_1, station_2):
    from_station = driver.find_element(By.XPATH, '//input[@placeholder="from station"]')
    from_station.clear()
    from_station.send_keys(station_1 + Keys.DOWN + Keys.ENTER)
    time.sleep(1)
    driver.find_element(By.XPATH, '//div[@class="list showslow"]').click()
    
    

    to_station = driver.find_element(By.XPATH, '//input[@placeholder="to station"]')
    to_station.clear()
    to_station.send_keys(station_2 + Keys.DOWN+ Keys.ENTER)
    time.sleep(1)
    driver.find_element(By.XPATH, '//div[@class="list showslow"]').click()

    # Get the HTML content of the div with class "srhres newbg inline alt"
    link = driver.find_element(By.XPATH, '//div[@id="SrhDiv"]').click()
    div_content = driver.find_element(By.XPATH, "//div[@class ='srhres newbg inline alt']").get_attribute("outerHTML")
    text_list = extract_text_and_links(div_content)
    # print(text_list)
    time.sleep(10000)
    driver.quit()

perform_search("Kings Circle", "Ville Parle")

driver.quit()