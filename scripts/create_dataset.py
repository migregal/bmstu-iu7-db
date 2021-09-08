from concurrent.futures import ThreadPoolExecutor
import csv
import datetime
from enum import unique
from faker import Faker
from os import path as p, pardir
import random


goods_id, users_id = [], []
employees_id, shops_id = [], []

def create_goods(dataset: str, count: int = 1000):
    global goods_id

    fake = Faker()
    with open(p.join(dataset, "goods.csv"), "w", newline='') as csv_file:
        writer = csv.writer(csv_file, delimiter=',')
        writer.writerow(
            [
                'id',
                'name',
                'description',
                'year',
                'manufacturer',
                'manufacturer_website'
            ]
        )
        for i in range(count):
            goods_id.append(fake.unique.uuid4()),
            writer.writerow(
                [
                    goods_id[-1],
                    fake.first_name(),
                    fake.text(),
                    random.randint(1700, 2021),
                    fake.company(),
                    fake.safe_domain_name()
                ]
            )


def create_shops(dataset: str, count: int = 1000):
    global shops_id

    fake = Faker()
    with open(p.join(dataset, "shops.csv"), "w", newline='') as csv_file:
        writer = csv.writer(csv_file, delimiter=',')
        writer.writerow(
            [
                'id',
                'company',
                'name',
                'latitude',
                'longitude',
                'registered'
            ]
        )
        for i in range(count):
            shops_id.append(fake.unique.uuid4()),
            latlng = fake.unique.latlng()
            writer.writerow(
                [
                    shops_id[-1],
                    fake.company(),
                    fake.first_name(),
                    latlng[0],
                    latlng[1],
                    fake.date_this_century().isoformat()
                ]
            )


def create_employees(dataset: str, count: int = 1000):
    global employees_id, shops_id

    fake = Faker()
    with open(p.join(dataset, "employees.csv"), "w", newline='') as csv_file:
        writer = csv.writer(csv_file, delimiter=',')
        writer.writerow(
            [
                'id',
                'shop_id',
                'job',
                'first_name',
                'last_name',
                'email',
                'phone',
                'salary'
            ]
        )
        for i in range(count):
            employees_id.append(fake.unique.uuid4())
            writer.writerow(
                [
                    employees_id[-1],
                    random.sample(shops_id, 1)[0],
                    fake.job(),
                    fake.first_name(),
                    fake.last_name(),
                    fake.unique.email(),
                    fake.unique.phone_number(),
                    random.randint(1, 100_000)
                ]
            )


def create_users(dataset: str, count: int = 1000):
    global users_id

    fake = Faker()
    with open(p.join(dataset, "users.csv"), "w", newline='') as csv_file:
        writer = csv.writer(csv_file, delimiter=',')
        writer.writerow(
            [
                'id',
                'first_name',
                'last_name',
                'email',
                'phone',
                'registered'
            ]
        )
        for i in range(count):
            users_id.append(fake.unique.uuid4())
            writer.writerow(
                [
                    users_id[-1],
                    fake.first_name(),
                    fake.last_name(),
                    fake.unique.email(),
                    fake.unique.phone_number(),
                    fake.date_this_century().isoformat()
                ]
            )


def create_reviews(dataset: str, count: int = 1000, max_rating: float = 10.0):
    global shops_id, employees_id, goods_id, users_id

    # def get_ids(fname: str):
    #     ids = set()
    #     with open(p.join(dataset, fname), "r", newline='') as fin:
    #         ids |= {l['id'] for l in csv.DictReader(fin, delimiter=',')}
    #     return list(ids)

    fake = Faker()

    # shops_id = get_ids("shops.csv")
    # goods_id = get_ids("goods.csv")
    # employees_id = get_ids("employees.csv")
    # users_id = get_ids("users.csv")

    with open(p.join(dataset, "reviews.csv"), "w", newline='') as csv_file:
        writer = csv.writer(csv_file, delimiter=',')
        writer.writerow(
            [
                'id',
                'shop_id',
                'good_id',
                'employee_id',
                'reviewer_id',
                'date',
                'comment',
                'good_rating',
                'shop_rating',
                'employee_rating',
            ]
        )
        for i in range(count):
            writer.writerow(
                [
                    fake.unique.uuid4(),
                    random.sample(shops_id, 1)[0],
                    random.sample(goods_id, 1)[0],
                    random.sample(employees_id, 1)[0],
                    random.sample(users_id, 1)[0],
                    fake.date_time_this_century().isoformat(),
                    fake.text()[:2000],
                    max_rating * random.random(),
                    max_rating * random.random(),
                    max_rating * random.random(),
                ]
            )

def run_io_tasks_in_parallel(tasks):
    with ThreadPoolExecutor() as executor:
        running_tasks = [executor.submit(task) for task in tasks]
        for running_task in running_tasks:
            running_task.result()

def main():
    dpath = p.abspath(p.join(p.dirname(p.abspath(__file__)), pardir))
    dataset = p.join(dpath, "dataset")

    size = 1000

    print("parallel part", datetime.datetime.now().strftime("%H:%M:%S"))
    run_io_tasks_in_parallel([
        lambda: create_goods(dataset, size),
        lambda: create_shops(dataset, size),
        lambda: create_users(dataset, size),
    ])

    print("normal part", datetime.datetime.now().strftime("%H:%M:%S"))
    create_employees(dataset, size)
    create_reviews(dataset, size)


if __name__ == "__main__":
    main()
