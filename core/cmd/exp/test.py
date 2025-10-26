import praw
import requests

if __name__ == '__main__':
    # Store the original request method
    original_request = requests.Session.request


    def logged_request(self, method, url, **kwargs):
        print(f"\n{'=' * 60}")
        print(f"METHOD: {method}")
        print(f"URL: {url}")
        print(f"\nHEADERS:")
        for key, value in kwargs.get('headers', {}).items():
            print(f"  {key}: {value}")
        print(f"\nDATA: {kwargs.get('data', 'None')}")
        print(f"PARAMS: {kwargs.get('params', 'None')}")
        print(f"{'-' * 60}\n")

        # Make the actual request
        response = original_request(self, method, url, **kwargs)
        print(f"RESPONSE STATUS: {response.status_code}")
        return response


    # Patch the request method
    requests.Session.request = logged_request

    clientID = ""
    clientSecret = ""

    reddit = praw.Reddit(
        client_id=clientID,
        client_secret=clientSecret,
        password="",
        user_agent="golang:myapp:v1.0 (by /u/YOUR_USERNAME)",
        username="",
    )

    me = reddit.user.me()
    print(me)

    for item in me.saved(limit=5):
        print(item.id)
        post = reddit.submission(id=item.id)
        print(post.media_metadata)
