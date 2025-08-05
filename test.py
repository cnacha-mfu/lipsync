from lipsync import LipSync

lip = LipSync(
    model='wav2lip',
    checkpoint_path='models/wav2lip.pth',
    nosmooth=True,
    device='cuda',
    cache_dir='cache',
    img_size=96,
    save_cache=True,
)

lip.sync(
    'avatar_speaking.mp4',
    'question.mp3',
    'output/result.mp4',
)