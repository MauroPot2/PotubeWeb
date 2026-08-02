import unittest

from fastapi import HTTPException

from app import main


class PotubeBackendTests(unittest.TestCase):
    def setUp(self):
        main._reset_rate_limits_for_tests()

    def test_safe_stem_removes_unsafe_characters(self):
        self.assertEqual(main._safe_stem('../ciao<>:"?.mp4'), 'ciao.mp4')

    def test_rate_limit_allows_configured_free_quota(self):
        original_limit = main.MAX_DAILY_CONVERSIONS
        original_window = main.RATE_LIMIT_WINDOW_SECONDS
        try:
            main.MAX_DAILY_CONVERSIONS = 3
            main.RATE_LIMIT_WINDOW_SECONDS = 86400

            remaining, _ = main._consume_rate_limit('client-a', now=1000)
            self.assertEqual(remaining, 2)
            remaining, _ = main._consume_rate_limit('client-a', now=1001)
            self.assertEqual(remaining, 1)
            remaining, _ = main._consume_rate_limit('client-a', now=1002)
            self.assertEqual(remaining, 0)

            with self.assertRaises(HTTPException) as context:
                main._consume_rate_limit('client-a', now=1003)
            self.assertEqual(context.exception.status_code, 429)
        finally:
            main.MAX_DAILY_CONVERSIONS = original_limit
            main.RATE_LIMIT_WINDOW_SECONDS = original_window

    def test_rate_limit_is_separate_per_client(self):
        original_limit = main.MAX_DAILY_CONVERSIONS
        try:
            main.MAX_DAILY_CONVERSIONS = 1
            main._consume_rate_limit('client-a', now=1000)
            remaining, _ = main._consume_rate_limit('client-b', now=1000)
            self.assertEqual(remaining, 0)
        finally:
            main.MAX_DAILY_CONVERSIONS = original_limit


if __name__ == '__main__':
    unittest.main()
