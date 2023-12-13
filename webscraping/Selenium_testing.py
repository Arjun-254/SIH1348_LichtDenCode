from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By 
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

service = Service(executable_path="chromedriver.exe")
driver = webdriver.Chrome(service=service)  

driver.get("https://www.google.com")


WebDriverWait(driver,5).until(
    EC.presence_of_element_located((By.CLASS_NAME,"gLFyf"))
)


input_element = driver.find_element(By.CLASS_NAME,"gLFyf")
input_element.clear()

input_element.send_keys("Selenium Documentation"+Keys.ENTER)

WebDriverWait(driver,5).until(
    EC.presence_of_element_located((By.PARTIAL_LINK_TEXT,"Selenium Documentation"))
)
link = driver.find_element(By.PARTIAL_LINK_TEXT,"Selenium Documentation")
link.click()

time.sleep(5)

driver.quit()