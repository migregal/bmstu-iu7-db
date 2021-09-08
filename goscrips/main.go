package main

import (
	"bmstu_db_filler/structs"
	"encoding/csv"
	"fmt"
	"math/rand"
	"os"
	"sync"
)

const (
	dirpath = "../dataset/"
	count   = 1000
)

var (
	wg           sync.WaitGroup
	shop_ids     = make([]string, 0, count)
	good_ids     = make([]string, 0, count)
	user_ids     = make([]string, 0, count)
	employee_ids = make([]string, 0, count)
)

func generateUsers(count int, mutex chan interface{}) {
	defer wg.Done()
	file, err := os.Create(dirpath + "users.csv")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	err = writer.Write(structs.GetUsersHeaders())
	if err != nil {
		panic(err)
	}

	for i := 0; i < count; i++ {
		mutex <- struct{}{}
		user := structs.GetRandomUsers()
		<-mutex

		user_ids = append(user_ids, user.Id)

		err = writer.Write(user.ToSlice())
		if err != nil {
			panic(err)
		}
	}
}

func generateGoods(count int, mutex chan interface{}) {
	defer wg.Done()
	file, err := os.Create(dirpath + "goods.csv")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	err = writer.Write(structs.GetGoodsHeaders())
	if err != nil {
		panic(err)
	}

	for i := 0; i < count; i++ {
		mutex <- struct{}{}
		good := structs.GetRandomGood(10.0)
		<-mutex

		good_ids = append(good_ids, good.Id)

		err = writer.Write(good.ToSlice())
		if err != nil {
			panic(err)
		}
	}
}

func generateShops(count int, mutex chan interface{}) {
	defer wg.Done()
	file, err := os.Create(dirpath + "shops.csv")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	err = writer.Write(structs.GetShopsHeaders())
	if err != nil {
		panic(err)
	}

	for i := 0; i < count; i++ {
		mutex <- struct{}{}
		shop := structs.GetRandomShop()
		<-mutex

		shop_ids = append(shop_ids, shop.Id)

		err = writer.Write(shop.ToSlice())
		if err != nil {
			panic(err)
		}
	}
}

func generateEmployees(count int) {
	file, err := os.Create(dirpath + "employees.csv")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	err = writer.Write(structs.GetEmployeeHeaders())
	if err != nil {
		panic(err)
	}

	for i := 0; i < count; i++ {
		v := structs.GetRandomEmployee(shop_ids[rand.Intn(len(shop_ids))])

		employee_ids = append(employee_ids, v.Id)

		err = writer.Write(v.ToSlice())
		if err != nil {
			panic(err)
		}
	}
}

func generateReviews(count int) {
	file, err := os.Create(dirpath + "reviews.csv")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	err = writer.Write(structs.GetReviewsHeaders())
	if err != nil {
		panic(err)
	}

	for i := 0; i < count; i++ {
		err = writer.Write(
			structs.GetRandomReviews(
				10.0,
				shop_ids[rand.Intn(len(shop_ids))],
				good_ids[rand.Intn(len(good_ids))],
				employee_ids[rand.Intn(len(employee_ids))],
				user_ids[rand.Intn(len(user_ids))],
			).ToSlice(),
		)

		if err != nil {
			panic(err)
		}
	}
}

func main() {
	mutex := make(chan interface{}, 1)

	fmt.Println("Users")
	wg.Add(1)
	go generateUsers(count, mutex)

	fmt.Println("Goods")
	wg.Add(1)
	go generateGoods(count, mutex)

	fmt.Println("Shops")
	wg.Add(1)
	go generateShops(count, mutex)

	wg.Wait()

	fmt.Println("Employeers")
	generateEmployees(count)

	fmt.Println("Reviews")
	generateReviews(count)

	fmt.Println("Finished")
}
