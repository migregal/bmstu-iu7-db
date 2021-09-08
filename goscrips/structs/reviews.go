package structs

import (
	"fmt"
	"github.com/bxcodec/faker/v3"
	"math/rand"
)

type Reviews struct {
	Id             string  `faker:"uuid_hyphenated,unique"`
	ShopId         string  `faker:"-"`
	GoodId         string  `faker:"-"`
	EmployeeId     string  `faker:"-"`
	ReviewerId     string  `faker:"-"`
	Date           string  `faker:"date"`
	Comment        string  `faker:"paragraph,unique"`
	GoodRating     float32 `faker:"-"`
	ShopRating     float32 `faker:"-"`
	EmployeeRating float32 `faker:"-"`
}

func (s Reviews) ToSlice() []string {
	return []string{
		s.Id,
		s.ShopId,
		s.GoodId,
		s.EmployeeId,
		s.ReviewerId,
		s.Date,
		s.Comment,
		fmt.Sprintf("%f", s.GoodRating),
		fmt.Sprintf("%f", s.ShopRating),
		fmt.Sprintf("%f", s.EmployeeRating),
	}
}

func GetReviewsHeaders() []string {
	return []string{
		"id",
		"shop_id",
		"good_id",
		"employee_id",
		"reviewer_id",
		"date",
		"comment",
		"good_rating",
		"shop_rating",
		"employee_rating",
	}
}

func GetRandomReviews(maxRating float32, shop string, good string, employee string, reviewer string) Reviews {
	t := Reviews{}

	err := faker.FakeData(&t)
	if err != nil {
		panic(err)
	}

	t.GoodRating = maxRating * rand.Float32()
	t.ShopRating = maxRating * rand.Float32()
	t.EmployeeRating = maxRating * rand.Float32()

	t.ShopId = shop
	t.GoodId = good
	t.EmployeeId = employee
	t.ReviewerId = reviewer
	return t
}
