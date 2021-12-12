package external

import (
	"context"
	"time"

	"github.com/go-redis/cache/v8"
	"github.com/go-redis/redis/v8"
)

var ctx = context.Background()

type RedisDatabase struct {
	Client *redis.Client
	Cache  *cache.Cache
}

func NewRedisDatabase(address, password string) (*RedisDatabase, error) {
	client := redis.NewClient(&redis.Options{
		Addr:     address,
		Password: password,
		DB:       0,
	})

	if err := client.Ping(ctx).Err(); err != nil {
		return nil, err
	}

	return &RedisDatabase{
		Client: client,
		Cache: cache.New(&cache.Options{
			Redis:      client,
			LocalCache: cache.NewTinyLFU(1000, time.Minute),
		}),
	}, nil
}
