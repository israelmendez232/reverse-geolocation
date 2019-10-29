# Reverse Geocoding
Usado para saber a localização do usuário através dos pontos de Latitude e Longitude. Usando uma API externa e script em Python.

<br>

## Elementos
**Geolocalização**

<br>

API gratuita utilizada para puxar os dados é [BigDataCloud](https://www.bigdatacloud.com/geocoding-apis/free-reverse-geocode-to-city-api?gclid=EAIaIQobChMIkKTk7Ze_5QIVFwWRCh35AQ5nEAAYASAAEgKOD_D_BwE). Apesar de gratuita, ela possui um limite de `50,000 queries/month`. Se você consumir uma quantidade grande de requisições da AP, eles - provavelmente - irão banir seu IP e dificultar o acesso.

**CEP**

<br>

API gratuita e aberta para saber o bairro a partir do CEP que foi usada é [WideApps](https://apps.widenet.com.br/busca-cep/api-de-consulta). Aparentemente, sem nenhum limite.

<br>

## Essencial:
Elementos que se apresentam no script:
- **Input:** CSV com coluna existente dos dados de `Latitude` e `Longitude` / ou `CEP`;
- **Output:** CSV com uma nova coluna com dados de `Bairro` (na API da Geolocaliação é chamado de *city_district*), já na de CEP é chamado de *district*.


<br>

## Processo
Segue o passo-a-passo do script:
1. Abre um CSV que contém os pontos de interesse (Latitude e Longitude, ou CEP);
2. Faz um Loop por Row, pegando cada ponto de interesse;
    - Puxa os pontos de referência e faz o request na API;
    - Coloca o valor retornado (city_district / district = bairro ou região) em uma nova coluna;
    - Próxima row, até acabar esse loop.
3. Finaliza com uma DF nova, printando os resultados para verificação;
4. Exporta essa DF em um novo csv.
