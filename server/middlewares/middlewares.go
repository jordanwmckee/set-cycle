package middlewares

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jordanwmckee/sets-app/utils/token"
)

func JwtAuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		isAccessToken, err := token.ValidAccessToken(c)

		// if there is an error, return a 401
		if err != nil {
			c.String(http.StatusUnauthorized, "Unauthorized")
			c.Abort()
			return
		}

		// if the token is not an access token, return a 400
		if !isAccessToken {
			c.String(http.StatusBadRequest, "Invalid token")
			c.Abort()
			return
		}

		c.Next()
	}
}
