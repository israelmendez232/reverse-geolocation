import os
import json
import requests
import pandas as pd

file = 'files/results-20191029-152807.csv'

# Arquivo antigo
def oldCSV(file):
    return pd.read_csv(file)

# Requisição da API Aberta
def reverseGeo(lat, long): 
    url = "https://api.bigdatacloud.net/data/reverse-geocode-client"

    headers = {
        'Content-Type': "application/json"
    }

    data = {
        'latitude': lat, 
        'longitude': long,
        'Content-Type': 'application/json',
        'localityLanguage': 'pt'
    }

    response = requests.request("GET", url, headers=headers, params=data)
    return json.loads(response.text)

# Salvando o arquivo para depois uso na pasta de files
def newCSV(df):
    arquivo = 'files/bairroVetSmart.csv'

    ## Se o arquivo já existir, excluir o antigo. Se não, criar com os dados já da API.
    if os.path.exists(arquivo):
        os.remove(arquivo) 
    else: 
        df.drop(columns=['latitude', 'longitude']) # Não é mais necessário as tabelas de latitude e longitude
        df.to_csv(arquivo, index=False)

def main(file):
    # Pegando o Arquivo antigo com Lat e Long:
    df = oldCSV(file)
    df['Bairro'] = ""

    print(" ===> Começando verificação do GeoLocation pela API. \n")
    print("Quantidade: Linha Atual / Total")
    for index, row in df.iterrows(): 
        address = reverseGeo(row['latitude'], row['longitude'])

        try: 
            cityDistrict = address['locality']
            df.at[index,'Bairro'] = cityDistrict
        except: 
            if address['description']:
                print("\n Problema com a API. Confira a mensagem de erro:")
                print(address['description'])
                return

            print("Erro para achar o bairro da linha {}".format(str(index)))
            df.at[index,'Bairro'] = None

        # Passa quantas linhas faltam para acabar.
        print("Quantidade: {} / {} \r".format(str(index), df.shape[0]), end='', flush=True)
    
    print(df)
    newCSV(df)

main(file)
