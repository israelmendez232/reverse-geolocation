import requests
import json

cepCode="1317-000"

url = "http://apps.widenet.com.br/busca-cep/api/cep/{}.json".format(cepCode)

response = requests.request("GET", url, headers={'User-Agent': "PetLove / 1.0.1"})
teste = json.loads(response.text)

try:
    print(teste['district'])
except:
    print("Erro.", teste['message'])












