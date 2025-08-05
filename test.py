from lipsync import LipSync

lip = LipSync(
    model='wav2lip',
    checkpoint_path='weights/wav2lip.pth',
    nosmooth=True,
    device='cuda',
    cache_dir='cache',
    img_size=96,
    save_cache=True,
)

lip.sync(
    'source/person.mp4',
    'source/audio.wav',
    'result.mp4',
)