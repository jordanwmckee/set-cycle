package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jordanwmckee/sets-app/models"
	"github.com/jordanwmckee/sets-app/utils/token"
)

// RefreshToken is a controller function that generates a new access token
// from a valid refresh token.
func RefreshToken(c *gin.Context) {
	// first, ensure a refresh token was passed as a query parameter
	if c.Query("token") == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "refresh token is required"})
		return
	}

	// verify token is a refresh token, and not an access token
	isAccessToken, err := token.ValidAccessToken(c)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if isAccessToken {
		c.JSON(http.StatusBadRequest, gin.H{"error": "token is not a refresh token"})
		return
	}

	user_id, err := token.ExtractTokenID(c)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Generate a new access token from the refresh token
	token, err := token.GenerateAccessToken(user_id)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"access_token": token})
}

// CurrentUser is a controller function that returns the current user.
func CurrentUser(c *gin.Context) {
	uid, err := token.ExtractTokenID(c)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	u, err := models.GetUserByID(uid)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "success", "data": u})
}

func DeleteUser(c *gin.Context) {
	uid, err := token.ExtractTokenID(c)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// delete user from database
	err = models.DeleteUser(uid)

	if err != nil {
		c.JSON(500, gin.H{"error": "unable to delete user"})
		return
	}

	c.JSON(200, gin.H{"message": "user deleted"})
}

type UserInput struct {
	AppleUserID string `json:"apple_user_id" binding:"required"`
}

// LoginOrRegister is a controller function that handles user login or registration.
func Authenticate(c *gin.Context) {
	var input UserInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	u := models.User{
		AppleUserID: input.AppleUserID,
	}

	if !u.Exists() {
		// user does not exist, create new user
		_, err := u.SaveUser()

		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
	}

	tokens, err := models.LoginCheck(u.AppleUserID)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "username or password is incorrect."})
		return
	}

	c.JSON(http.StatusOK, gin.H{"refresh_token": tokens.RefreshToken, "access_token": tokens.AccessToken})
}

type LoginInput struct {
	AppleUserID string `json:"apple_user_id" binding:"required"`
}

// Login is a controller function that handles user login.
// It returns a refresh token and an access token.
func Login(c *gin.Context) {
	var input LoginInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	u := models.User{
		AppleUserID: input.AppleUserID,
	}

	tokens, err := models.LoginCheck(u.AppleUserID)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "username or password is incorrect."})
		return
	}

	c.JSON(http.StatusOK, gin.H{"refresh_token": tokens.RefreshToken, "access_token": tokens.AccessToken})
}

type RegisterInput struct {
	AppleUserID string `json:"apple_user_id" binding:"required"`
}

// Register is a controller function that handles user registration.
func Register(c *gin.Context) {
	var input RegisterInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	u := models.User{
		AppleUserID: input.AppleUserID,
	}

	_, err := u.SaveUser()

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "registration success"})
}
