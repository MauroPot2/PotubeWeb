import unittest

from backend.app.youtube_case_study import _is_allowed_youtube_url


class YoutubeCaseStudyTests(unittest.TestCase):
    def test_accepts_supported_youtube_hosts(self):
        self.assertTrue(_is_allowed_youtube_url('https://www.youtube.com/watch?v=abc123'))
        self.assertTrue(_is_allowed_youtube_url('https://music.youtube.com/watch?v=abc123'))
        self.assertTrue(_is_allowed_youtube_url('https://youtu.be/abc123'))

    def test_rejects_non_youtube_hosts(self):
        self.assertFalse(_is_allowed_youtube_url('https://example.com/watch?v=abc123'))
        self.assertFalse(_is_allowed_youtube_url('https://youtube.com.evil.example/watch?v=abc123'))

    def test_rejects_credentials_in_url(self):
        self.assertFalse(_is_allowed_youtube_url('https://user:pass@youtube.com/watch?v=abc123'))


if __name__ == '__main__':
    unittest.main()
