import bs4, csv, requests, re

base_url = "http://www.camsis.stir.ac.uk/hiscam/v1_3_1/"

soup = bs4.BeautifulSoup(requests.get(base_url).text, "html5lib")

for link in soup.find_all('a', {'href': re.compile("dat")}):
    url = base_url + link['href']
    filename = link['href'].replace('.dat','.csv')
    response = requests.get(url)

    with open(filename,'w') as f:
        f.write(response.content)
