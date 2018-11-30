import requests

interface = 'http://quotes.money.163.com/service/chddata.html?code=1000333&start=20170101&end=20180201&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;VOTURNOVER;VATURNOVER '
response = requests.get(interface)
with open('finance.csv', 'w') as f:
    f.write(response.text)
