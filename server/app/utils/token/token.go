package token

import (
	"errors"
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	jwt "github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

// GenerateAccessToken generates an access token from a user ID.
// The access token is signed with the API secret and has a lifespan of 1 hour.
func GenerateAccessToken(user_id uint) (string, error) {
	tokenLifespan, err := strconv.Atoi(os.Getenv("TOKEN_HOUR_LIFESPAN"))

	if err != nil {
		return "", err
	}

	// Create and sign access token
	claims := jwt.MapClaims{}
	claims["authorized"] = true
	claims["user_id"] = user_id
	claims["exp"] = time.Now().Add(time.Hour * time.Duration(tokenLifespan)).Unix()
	accessToken := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	accessTokenString, err := accessToken.SignedString([]byte(os.Getenv("API_SECRET")))

	if err != nil {
		return "", err
	}

	return accessTokenString, nil
}

type TokenResponse struct {
	RefreshToken string
	AccessToken  string
}

// GenerateTokens generates a refresh token and an access token from a user ID.
func GenerateTokenPair(user_id uint) (TokenResponse, error) {
	// Create and sign access token
	accessTokenString, err := GenerateAccessToken(user_id)

	if err != nil {
		return TokenResponse{}, err
	}

	// Create and sign refresh token
	refreshClaims := jwt.MapClaims{}
	refreshClaims["authorized"] = true
	refreshClaims["user_id"] = user_id
	refreshToken := jwt.NewWithClaims(jwt.SigningMethodHS256, refreshClaims)
	refreshTokenString, err := refreshToken.SignedString([]byte(os.Getenv("API_SECRET")))
	if err != nil {
		return TokenResponse{}, err
	}

	return TokenResponse{
		RefreshToken: refreshTokenString,
		AccessToken:  accessTokenString,
	}, nil
}

// ParseToken parses a token from the encrypted token string.
// It returns an error if the token is invalid.
// It returns a token if the token is valid.
func ParseToken(tokenString string) (*jwt.Token, error) {
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {

		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}

		return []byte(os.Getenv("API_SECRET")), nil
	})

	if err != nil {
		return nil, err
	}

	return token, nil
}

// ValidAccessToken checks if a token is an access
// token, then if the access token is valid.
func ValidAccessToken(c *gin.Context) (bool, error) {
	exp, err := ExtractTokenExp(c)

	if err != nil {
		return false, err
	}

	if exp == 0 {
		return false, nil
	}

	return true, nil
}

// TokenValid checks if a token is valid.
func TokenValid(c *gin.Context) error {
	tokenString := ExtractToken(c)

	_, err := ParseToken(tokenString)

	if err != nil {
		return err
	}

	return nil
}

// ExtractToken extracts the token from a request.
// It first checks the query string, then the Authorization header.
// It returns an empty string if no token is found.
func ExtractToken(c *gin.Context) string {
	token := c.Query("token")

	if token != "" {
		return token
	}

	bearerToken := c.Request.Header.Get("Authorization")

	if len(strings.Split(bearerToken, " ")) == 2 {
		return strings.Split(bearerToken, " ")[1]
	}

	return ""
}

// ExtractTokenExp extracts a token expiration date from a token.
// It returns an error if the token is invalid.
// It returns 0 if the token does not have an expiration date.
func ExtractTokenExp(c *gin.Context) (int64, error) {
	tokenString := ExtractToken(c)
	token, err := ParseToken(tokenString)

	if err != nil {
		return 0, err
	}

	claims, ok := token.Claims.(jwt.MapClaims)

	if ok && token.Valid {
		expRaw, ok := claims["exp"]
		if !ok {
			// No "exp" claim, indicating it's a refresh token
			return 0, nil
		}

		// Check if the value is an int64
		if expInt, ok := expRaw.(float64); ok {
			// Type assertion successful, convert to int64
			return int64(expInt), nil
		}

		return 0, errors.New("error reading expiration from token claims")
	}

	return 0, nil
}

// ExtractTokenID extracts a user ID from a token.
// It returns an error if the token is invalid.
func ExtractTokenID(c *gin.Context) (uint, error) {
	tokenString := ExtractToken(c)
	token, err := ParseToken(tokenString)

	if err != nil {
		return 0, err
	}

	claims, ok := token.Claims.(jwt.MapClaims)

	if ok && token.Valid {
		uid, err := strconv.ParseUint(fmt.Sprintf("%.0f", claims["user_id"]), 10, 32)

		if err != nil {
			return 0, err
		}

		return uint(uid), nil
	}

	return 0, nil
}
