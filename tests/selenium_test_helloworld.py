
import selenium
from selenium.webdriver.chrome.options import Options
from time import sleep
from random import randint
from os import environ

def get_driver():
    """Function that bootstraps chrome webdriver

    Returns:
        selenium.webdriver.Chrome -- Instance of Selenium Chrome webdriver
    """
    options = Options()
    options.headless = True
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-gpu')
    options.add_argument('--window-size=1280x1024')
    options.add_argument('--user-data-dir=/tmp/user-data')
    options.add_argument('--hide-scrollbars')
    options.add_argument('--enable-logging')
    options.add_argument('--log-level=0')
    options.add_argument('--v=99')
    options.add_argument('--single-process')
    options.add_argument('--data-path=/tmp/data-path')
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--homedir=/tmp')
    options.add_argument('--disk-cache-dir=/tmp/cache-dir')
    options.add_argument('--disable-web-security')

    return selenium.webdriver.Chrome(options=options, service_log_path='/tmp/chromedriver.log')

def test_message():
    url=environ.get('URL')

    expected = 'Hello world!'
    driver = get_driver()
    driver.get(url)
    sleep(5)
    message = driver.find_element_by_id("message")


    assert message.text == expected

if __name__ == '__main__':
    test_message()
