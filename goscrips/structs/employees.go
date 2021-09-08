package structs

import (
	"fmt"
	"github.com/bxcodec/faker/v3"
	"math"
)

type Employees struct {
	Id         string `faker:"uuid_hyphenated,unique"`
	ShopId     string `faker:"-"`
	Job        string `faker:"sentence"`
	FirstName  string `faker:"first_name"`
	LastName   string `faker:"last_name"`
	Email      string `faker:"email,unique"`
	Phone      string `faker:"phone_number,unique"`
	Salary 	float64 `faker:"amount"`
}

func (s Employees) ToSlice() []string {
	return []string{
		s.Id,
		s.ShopId,
		s.Job,
		s.FirstName,
		s.LastName,
		s.Email,
		s.Phone,
		fmt.Sprintf("%d", int(math.Round(s.Salary))),
	}
}

func GetEmployeeHeaders() []string {
	return []string{"id", "shop_id", "job", "first_name", "last_name", "email", "phone", "salary"}
}

func GetRandomEmployee(shopId string) Employees {
	t := Employees{}

	err := faker.FakeData(&t)
	if err != nil {
		panic(err)
	}

	t.ShopId = shopId

	return t
}
