import os
import json
import requests
import pandas as pd

file = 'files/results-20191028-105246.csv'

# Arquivo antigo
def oldCSV(file):
    return pd.read_csv(file)

# Requisição da API Aberta
def verificadorCEP(cepCode): 
    url = "http://apps.widenet.com.br/busca-cep/api/cep/{}.json".format(cepCode)

    response = requests.request("GET", url, headers={'User-Agent': "PetLove / 1.0.1"})
    teste = json.loads(response.text)

    try:
        print(teste['district'])
    except:
        print("Erro.", teste['message'])

    return json.loads(response.text)

# Salvando o arquivo para depois uso na pasta de files
def newCSV(df):
    arquivo = 'files/resultadoBairro.csv'

    ## Se o arquivo já existir, excluir o antigo. Se não, criar com os dados já da API.
    if os.path.exists(arquivo):
        os.remove(arquivo) 
    else: 
        df.to_csv(arquivo)

def main(file):
    # Pegando o Arquivo antigo com Lat e Long:
    df = oldCSV(file)
    df['Bairro'] = ""

    print(" ===> Começando verificação do GeoLocation pela API. \n")
    print("Quantidade: Linha Atual / Total")
    for index, row in df.iterrows(): 
        address = verificadorCEP(row['cep'])

        try: 
            cityDistrict = address['locality']
            df.at[index,'Bairro'] = cityDistrict
        except: 
            print("Erro para achar o bairro da linha {}".format(str(index)))
            df.at[index,'Bairro'] = None

        # Passa quantas linhas faltam para acabar.
        print("Quantidade: {} / {} \r".format(str(index), df.shape[0]), end='', flush=True)
    
    print(df)
    newCSV(df)

main(file)
