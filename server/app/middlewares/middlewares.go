package middlewares

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jordanwmckee/sets-app/utils/token"
)

// JwtAuthMiddleware is a middleware function that checks for a valid JWT token
func JwtAuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		isAccessToken, err := token.ValidAccessToken(c)

		// if there is an error, return a 401
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			c.Abort()
			return
		}

		// if the token is not an access token, return a 400
		if !isAccessToken {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid token"})
			c.Abort()
			return
		}

		c.Next()
	}
}
