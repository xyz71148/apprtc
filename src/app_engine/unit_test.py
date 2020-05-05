import unittest
import requests

from apprtc import get_room_parameters
class MyTestCase(unittest.TestCase):
    def test_something(self):
        res = requests.get("https://jie8.cc/api/utils/turnserver/auth")

        self.assertEqual(True, False)


if __name__ == '__main__':
    unittest.main()
