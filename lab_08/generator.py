import json
import datetime
from faker import Faker
from os import path as p
import schedule
import time


fake = Faker()
id = 0


def create_shops(dataset: str, count: int = 1000):
    global id

    data = []
    for i in range(count):
        latlng = fake.unique.latlng()
        data.append({
            'id': fake.unique.uuid4(),
            'company': fake.company(),
            'name': fake.first_name(),
            'latitude': latlng[0],
            'longitude': latlng[1],
            'registered': fake.date_this_century().isoformat()
        })

    fout = f'shops_{id}_{datetime.datetime.now().strftime("%Y-%m-%d_%H:%M:%S")}.json'
    id += 1
    with open(p.join(dataset, fout), "w", newline='') as json_file:
        json.dump(data, json_file, default=str)


def main():
    dpath = p.dirname(p.abspath(__file__))
    dataset = dpath

    size = 10_000

    schedule.every(5).seconds.do(create_shops, dataset=dataset, count=size)

    while True:
        schedule.run_pending()
        time.sleep(1)


if __name__ == "__main__":
    main()
