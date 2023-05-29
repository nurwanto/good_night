# Good Night API

## Asumptions:
- Does not handle authentication, use 'current_user_id' request body for simulation
- Does not implement user registration

## Installation:
- `bundle install`
- `rake db:create`
- `rake db:migrate`
- `rake db:seed`

## Running app:
- `rails s`

## Available endpoints
### 1. Get bed time history for all followed users
**Description**: An API endpoint to fetch last week's bed time history for all followed users.<br />
**Host:** `localhost:3000/api/v1/bed_time/history`<br />
**Method:** `GET`<br />
**Request body:**<br />
```
{
    "current_user_id": 22
}
```
**Response body:**
```
{
    "data": [
        {
            "id": 96,
            "user_id": 24,
            "bed_time": "2023-05-16 09:03:17.146142",
            "wake_up_time": "2023-05-16 20:46:18.084119",
            "duration": 42181.0
        },
        {
            "id": 95,
            "user_id": 24,
            "bed_time": "2023-05-17 16:27:30.297430",
            "wake_up_time": "2023-05-17 23:39:09.504786",
            "duration": 25899.0
        },
        {
            "id": 89,
            "user_id": 23,
            "bed_time": "2023-05-19 16:13:54.212129",
            "wake_up_time": "2023-05-19 22:11:54.238900",
            "duration": 21480.0
        }
    ]
}
```
<br />

### 2. Get Bed time history for a specific followed user
**Description:** An API endpoint to fetch last week's bed time history for a specific followed users.<br />
**Host:** `localhost:3000/api/v1/bed_time/history/:user_id` <br />
*example: `localhost:3000/api/v1/bed_time/history/23`*<br />
**Method:** GET <br />
**Request body:**
```
{
    "current_user_id": 22
}
```
**Response body:**
```
{
    "data": [
        {
            "user_id": 23,
            "user_name": "Bob",
            "bed_time_histories": [
                {
                    "bed_time": "2023-05-17T18:22:55.376Z",
                    "wake_up_time": "2023-05-17T20:18:28.286Z",
                    "duration": 6932.909092
                },
                {
                    "bed_time": "2023-05-16T23:52:42.964Z",
                    "wake_up_time": "2023-05-17T03:16:35.937Z",
                    "duration": 12232.973227
                },
                {
                    "bed_time": "2023-05-18T08:56:38.367Z",
                    "wake_up_time": "2023-05-18T12:54:00.598Z",
                    "duration": 14242.23099
                },
                {
                    "bed_time": "2023-05-19T16:13:54.212Z",
                    "wake_up_time": "2023-05-19T22:11:54.238Z",
                    "duration": 21480.026771
                }
            ]
        }
    ]
}
```

### 3. Set or Unset go to bed time and wake up time
**Description:** An API endpoint to set go to bed time and wake up time <br />
#### 3.1. Set go to bed time
**Host:** `localhost:3000/api/v1/bed_time/set_unset`<br />
**Method:** POST<br />
**Request body:**
```
{
    "current_user_id": 24,
    "type": "bed_time"
}
```
**Response body:**
```
{
    "message": "bed_time has been successfully updated at 2023-05-21 16:18:52 +0700"
}
```

#### 3.2. Set wake up time
**Host:** `localhost:3000/api/v1/bed_time/set_unset` <br />
**Method:** POST <br />
**Request body:**
```
{
    "current_user_id": 24,
    "type": "wake_up"
}
```
**Response body:**
```
{
    "message": "wake_up has been successfully updated at 2023-05-21 16:19:07 +0700"
}
```

### 4. Follow and Unfollow User API
**Description:** An API endpoint to follow and unfollow other user. <br/>

#### 4.1. Follow user
**Host:** `localhost:3000/api/v1/follow` <br/>
**Method:** POST <br/>
**Request body:**
```
{
    "current_user_id": 24,
    "target_user_id": 23,
    "action": "follow"
}
```
**Response body:**
```
{
    "message": "you have successfully follow user 23"
}
```

#### 4.2. Unfollow user
**Host:** `localhost:3000/api/v1/follow` <br/>
**Method:** POST <br/>
**Request body:**
```
{
    "current_user_id": 24,
    "target_user_id": 23,
    "action": "unfollow"
}
```
**Response body:**
```
{
    "message": "you have successfully unfollow user 23"
}
```

### 5. Get list of followers
**Description:** An API endpoint to fetch list all followers. <br/>
**Host:** `localhost:3000/api/v1/follow/followers` <br/>
**Method:** GET <br/>
**Request body:**
```
{
    "current_user_id": 24
}
```
**Response body:**
```
{
    "data": [
        {
            "id": 22,
            "name": "Alice",
            "created_at": "2023-05-20T07:10:27.870Z",
            "updated_at": "2023-05-20T07:10:27.870Z"
        },
        {
            "id": 23,
            "name": "Bob",
            "created_at": "2023-05-20T07:10:27.902Z",
            "updated_at": "2023-05-20T07:10:27.902Z"
        }
    ]
}
```

### 6. Get list of followed user
**Description:** An API endpoint to fetch list of followed users. <br/>
**Host:** `localhost:3000/api/v1/follow/followed` <br/>
**Method:** GET <br/>
**Request body:**
```
{
    "current_user_id": 22
}
```
**Response body:**
```
{
    "data": [
        {
            "id": 23,
            "name": "Bob",
            "created_at": "2023-05-20T07:10:27.902Z",
            "updated_at": "2023-05-20T07:10:27.902Z"
        },
        {
            "id": 24,
            "name": "Charlie",
            "created_at": "2023-05-20T07:10:27.926Z",
            "updated_at": "2023-05-20T07:10:27.926Z"
        }
    ]
}
```