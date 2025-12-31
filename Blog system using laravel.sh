# ===========================================
# POSTMAN COLLECTION (Save as blog-system.postman_collection.json)
# ===========================================
{
  "info": {
    "name": "University Blog System API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "JWT Authentication",
      "item": [
        {
          "name": "Login",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"email\": \"admin@blog.com\",\n  \"password\": \"password123\"\n}"
            },
            "url": {
              "raw": "http://127.0.0.1:8000/api/auth/login",
              "protocol": "http",
              "host": ["127", "0", "0", "1"],
              "port": "8000",
              "path": ["api", "auth", "login"]
            }
          }
        },
        {
          "name": "Get Profile",
          "request": {
            "method": "GET",
            "header": [
              {
                "key": "Authorization",
                "value": "Bearer {{token}}"
              },
              {
                "key": "Accept",
                "value": "application/json"
              }
            ],
            "url": {
              "raw": "http://127.0.0.1:8000/api/auth/profile",
              "protocol": "http",
              "host": ["127", "0", "0", "1"],
              "port": "8000",
              "path": ["api", "auth", "profile"]
            }
          }
        },
        {
          "name": "Logout",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Authorization",
                "value": "Bearer {{token}}"
              },
              {
                "key": "Accept",
                "value": "application/json"
              }
            ],
            "url": {
              "raw": "http://127.0.0.1:8000/api/auth/logout",
              "protocol": "http",
              "host": ["127", "0", "0", "1"],
              "port": "8000",
              "path": ["api", "auth", "logout"]
            }
          }
        }
      ]
    },
    {
      "name": "Mobile APIs",
      "item": [
        {
          "name": "Get All Posts",
          "request": {
            "method": "GET",
            "header": [
              {
                "key": "Accept",
                "value": "application/json"
              }
            ],
            "url": {
              "raw": "http://127.0.0.1:8000/api/posts",
              "protocol": "http",
              "host": ["127", "0", "0", "1"],
              "port": "8000",
              "path": ["api", "posts"]
            }
          }
        },
        {
          "name": "Get Single Post",
          "request": {
            "method": "GET",
            "header": [
              {
                "key": "Accept",
                "value": "application/json"
              }
            ],
            "url": {
              "raw": "http://127.0.0.1:8000/api/posts/my-first-blog-post",
              "protocol": "http",
              "host": ["127", "0", "0", "1"],
              "port": "8000",
              "path": ["api", "posts", "my-first-blog-post"]
            }
          }
        },
        {
          "name": "Submit Comment",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              },
              {
                "key": "Accept",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"author_name\": \"John Doe\",\n  \"author_email\": \"john@example.com\",\n  \"content\": \"Great post! Very informative.\"\n}"
            },
            "url": {
              "raw": "http://127.0.0.1:8000/api/posts/my-first-blog-post/comments",
              "protocol": "http",
              "host": ["127", "0", "0", "1"],
              "port": "8000",
              "path": ["api", "posts", "my-first-blog-post", "comments"]
            }
          }
        },
        {
          "name": "Get Comments",
          "request": {
            "method": "GET",
            "header": [
              {
                "key": "Accept",
                "value": "application/json"
              }
            ],
            "url": {
              "raw": "http://127.0.0.1:8000/api/posts/my-first-blog-post/comments",
              "protocol": "http",
              "host": ["127", "0", "0", "1"],
              "port": "8000",
              "path": ["api", "posts", "my-first-blog-post", "comments"]
            }
          }
        }
      ]
    }
  ]
}

# ===========================================
# SETUP SCRIPT (Save as setup.sh)
# Run: bash setup.sh
# ===========================================
#!/bin/bash

echo "🚀 Setting up University Blog System..."

# Install PHP dependencies
echo "📦 Installing Composer dependencies..."
composer install

# Install Node dependencies
echo "📦 Installing NPM dependencies..."
npm install

# Copy environment file
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
fi

# Generate application key
echo "🔑 Generating application key..."
php artisan key:generate

# Generate JWT secret
echo "🔐 Generating JWT secret..."
php artisan jwt:secret

# Create database
echo "💾 Setting up database..."
read -p "Enter database name (default: blog_system): " db_name
db_name=${db_name:-blog_system}

mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS $db_name;"

# Update .env file
sed -i "s/DB_DATABASE=.*/DB_DATABASE=$db_name/" .env

# Run migrations
echo "🗄️ Running migrations..."
php artisan migrate

# Seed database
echo "🌱 Seeding database..."
php artisan db:seed --class=AdminSeeder

# Create screenshots directory
echo "📸 Creating screenshots directory..."
mkdir -p public/screenshots

# Build assets
echo "🎨 Building frontend assets..."
npm run build

# Clear cache
echo "🧹 Clearing cache..."
php artisan config:clear
php artisan cache:clear
php artisan route:clear

echo "✅ Setup complete!"
echo ""
echo "📋 Admin Credentials:"
echo "   Email: admin@blog.com"
echo "   Password: password123"
echo ""
echo "🌐 Start the server with: php artisan serve"
echo "   Visit: http://127.0.0.1:8000"

# ===========================================
# TEST SCRIPT (Save as test-api.sh)
# Run: bash test-api.sh
# ===========================================
#!/bin/bash

BASE_URL="http://127.0.0.1:8000"
TOKEN=""

echo "🧪 Testing University Blog System API..."
echo ""

# Test 1: Login
echo "1️⃣ Testing JWT Login..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@blog.com","password":"password123"}')

TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
    echo "❌ Login failed"
    echo $LOGIN_RESPONSE
    exit 1
else
    echo "✅ Login successful"
    echo "Token: ${TOKEN:0:50}..."
fi
echo ""

# Test 2: Get Profile
echo "2️⃣ Testing Get Profile..."
PROFILE_RESPONSE=$(curl -s -X GET "$BASE_URL/api/auth/profile" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json")

if echo $PROFILE_RESPONSE | grep -q "email"; then
    echo "✅ Profile retrieved successfully"
    echo $PROFILE_RESPONSE | python3 -m json.tool
else
    echo "❌ Failed to get profile"
fi
echo ""

# Test 3: Get All Posts
echo "3️⃣ Testing Get All Posts..."
POSTS_RESPONSE=$(curl -s -X GET "$BASE_URL/api/posts" \
  -H "Accept: application/json")

if echo $POSTS_RESPONSE | grep -q "data"; then
    echo "✅ Posts retrieved successfully"
    POST_COUNT=$(echo $POSTS_RESPONSE | grep -o '"total":[0-9]*' | cut -d':' -f2)
    echo "Total posts: $POST_COUNT"
else
    echo "❌ Failed to get posts"
fi
echo ""

# Test 4: Logout
echo "4️⃣ Testing Logout..."
LOGOUT_RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/logout" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json")

if echo $LOGOUT_RESPONSE | grep -q "Successfully logged out"; then
    echo "✅ Logout successful"
else
    echo "❌ Logout failed"
fi
echo ""

echo "🎉 API testing complete!"

# ===========================================
# SAMPLE DATA SEEDER (Add to database/seeders/DatabaseSeeder.php)
# ===========================================
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Post;
use App\Models\Comment;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Create admin user
        $admin = User::create([
            'name' => 'Admin User',
            'email' => 'admin@blog.com',
            'password' => Hash::make('password123'),
        ]);

        // Create sample posts
        $post1 = Post::create([
            'user_id' => $admin->id,
            'title' => 'Getting Started with Laravel',
            'content' => 'Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects.',
            'status' => 'published',
        ]);

        $post2 = Post::create([
            'user_id' => $admin->id,
            'title' => 'Understanding JWT Authentication',
            'content' => 'JSON Web Token (JWT) is an open standard that defines a compact and self-contained way for securely transmitting information between parties as a JSON object. This information can be verified and trusted because it is digitally signed.',
            'status' => 'published',
        ]);

        $post3 = Post::create([
            'user_id' => $admin->id,
            'title' => 'Draft Post Example',
            'content' => 'This is a draft post that should not be visible to the public.',
            'status' => 'draft',
        ]);

        // Create sample comments
        Comment::create([
            'post_id' => $post1->id,
            'author_name' => 'Jane Smith',
            'author_email' => 'jane@example.com',
            'content' => 'Great introduction to Laravel! Very helpful.',
        ]);

        Comment::create([
            'post_id' => $post1->id,
            'author_name' => 'Bob Johnson',
            'author_email' => 'bob@example.com',
            'content' => 'Thanks for sharing this. Looking forward to more posts.',
        ]);

        Comment::create([
            'post_id' => $post2->id,
            'author_name' => 'Alice Williams',
            'author_email' => 'alice@example.com',
            'content' => 'JWT is really powerful. This explanation is clear and concise.',
        ]);
    }
}

# ===========================================
# .gitignore (Make sure this is in your project root)
# ===========================================
/node_modules
/public/hot
/public/storage
/storage/*.key
/vendor
.env
.env.backup
.env.production
.phpunit.result.cache
Homestead.json
Homestead.yaml
auth.json
npm-debug.log
yarn-error.log
/.fleet
/.idea
/.vscode

# ===========================================
# Quick Installation Commands
# ===========================================

# Option 1: Manual Setup
composer create-project laravel/laravel university-blog-system
cd university-blog-system
composer require tymon/jwt-auth
composer require laravel/ui
php artisan vendor:publish --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider"
php artisan jwt:secret
php artisan ui bootstrap --auth
npm install && npm run build
# Then copy all the files from the artifacts above

# Option 2: After copying all files
php artisan key:generate
php artisan jwt:secret
php artisan migrate
php artisan db:seed --class=AdminSeeder
npm install && npm run build
php artisan serve

# ===========================================
# Testing Commands
# ===========================================

# Test JWT Login via curl
curl -X POST http://127.0.0.1:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@blog.com","password":"password123"}'

# Test Get Profile (replace TOKEN)
curl -X GET http://127.0.0.1:8000/api/auth/profile \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Accept: application/json"

# Test Get All Posts
curl -X GET http://127.0.0.1:8000/api/posts \
  -H "Accept: application/json"

# Test Submit Comment
curl -X POST http://127.0.0.1:8000/api/posts/getting-started-with-laravel/comments \
  -H "Content-Type: application/json" \
  -d '{"author_name":"Test User","author_email":"test@example.com","content":"Great post!"}'