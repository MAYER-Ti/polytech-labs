#!/usr/bin/env python3
import subprocess
import shlex

def record_screen():
    # Параметры записи
    duration = 15            # Длительность записи (сек)
    screen_res = "3000x1920"  # Разрешение экрана
    webcam_res = "640x480"   # Разрешение веб-камеры
    output_file = "output.mp4"  # Выходной файл

    # Команда ffmpeg с разными FPS для экрана и камеры
    cmd = f"""
    ffmpeg -y -loglevel error \
        -thread_queue_size 1024 \
        -f x11grab -video_size {screen_res} -framerate 30 -i :0.0 \

        -thread_queue_size 1024 \
        -f v4l2 -video_size {webcam_res} -framerate 30 -input_format mjpeg -i /dev/video0 \

        -f pulse -i alsa_input.usb-3142_Fifine_Microphone-00.mono-fallback \

        -filter_complex "
            [0:v]fps=30,setpts=N/FRAME_RATE/TB[screen];
            [1:v]fps=30,setpts=N/FRAME_RATE/TB[webcam];
            [webcam]scale=320:-1[cam_scaled];
            [screen][cam_scaled]overlay=x=main_w-overlay_w-10:y=10[v]" \

        -map "[v]" \
        -map 2:a \
        -c:v libx264 -preset fast -crf 23 -r 60 \
        -c:a aac -b:a 128k \
        -vsync 1 -async 1 \
        -t {duration} \
        {output_file}
    """

    # Запуск команды (удаляем переносы строк и лишние пробелы)
    subprocess.run(shlex.split(' '.join(cmd.split())), check=True)

if __name__ == "__main__":
    record_screen()



# #!/usr/bin/env python3
# import subprocess
# import shlex
#
# def record_screen():
#     # Минимальные параметры записи
#     duration = 15           # Длительность записи (сек)
#     screen_res = "3000x1920" # Разрешение экрана
#     webcam_res = "640x480"  # Разрешение веб-камеры
#     output_file = "output.mp4" # Выходной файл
#
#     # Минимальная команда ffmpeg
#     cmd = f"""
#     ffmpeg -y -loglevel error -thread_queue_size 1024 \
#         -f x11grab -video_size {screen_res} -framerate 30 -i :0.0 \
#         -f v4l2 -video_size {webcam_res} -framerate 15 -input_format mjpeg -i /dev/video0 \
#         -f pulse -i alsa_input.usb-3142_Fifine_Microphone-00.mono-fallback \
#         -filter_complex "[1:v]scale=320:-1,setpts=N/FRAME_RATE/TB[webcam];[0:v][webcam]overlay=x=main_w-overlay_w-10:y=10" \
#         -c:v libx264 -preset ultrafast -tune zerolatency -crf 23 -g 60 \
#         -c:a aac -b:a 128k \
#         -vsync 1 -async 1 \
#         -t {duration} \
#         {output_file}
#     """
#
#     # Запуск и ожидание завершения
#     subprocess.run(shlex.split(cmd), check=True)
#
# if __name__ == "__main__":
#     record_screen()


# from tqdm import tqdm
# import subprocess
# import time
#
# def record_with_progress():
#     cmd = [
#         "ffmpeg",
#         "-y", "-loglevel", "error",
#         "-f", "x11grab", "-video_size", "1920x1080", "-i", ":0.0",
#         "-f", "v4l2", "-i", "/dev/video0",
#         "-f", "alsa", "-i", "hw:1",
#         "-filter_complex", "[1:v]scale=320:-1[webcam];[0:v][webcam]overlay=main_w-overlay_w-10:10",
#         "-t", "5",
#         "-c:v", "libx264", "-preset", "fast",
#         "output_progress.mp4"
#     ]
#
#     process = subprocess.Popen(cmd)
#
#     # Красивый прогресс-бар
#     with tqdm(total=5, desc="Запись") as pbar:
#         for _ in range(5):
#             time.sleep(1)
#             pbar.update(1)
#
#     process.terminate()
#     print("\nГотово! Проверьте файл output_progress.mp4")
#
# record_with_progress()

# import subprocess
# import shlex
#
# # Конфигурация
# VIDEO_DEVICE = "/dev/video0"
# RESOLUTION = "640x480"
#
# # Команда FFmpeg (разделение видео на два потока и объединение их)
# cmd = f"""
#     ffmpeg -y -loglevel error \
#         -f x11grab -video_size {screen_res} -framerate 30 -i :0.0 \
#         -f v4l2 -video_size {webcam_res} -framerate 30 -i /dev/video0 \
#         -f pulse -i alsa_input.usb-3142_Fifine_Microphone-00.mono-fallback \
#         -filter_complex "[1:v]fps=30,scale=320:-1:flags=lanczos[webcam];[0:v][webcam]overlay=x=main_w-overlay_w-10:y=10,fps=30" \
#         -c:v h264_nvenc -preset fast -crf 23 \
#         -c:a aac -b:a 128k \
#         -t {duration} \
#         {output_file}
#     """
#
# ffmpeg_cmd =f"""
#           ffmpeg -y -loglevel error \
#         -f x11grab -video_size {screen_res} -framerate 30 -i :0.0 \
#         -f v4l2 -video_size {webcam_res} -framerate 30 -i /dev/video0 \
#         -f pulse -i alsa_input.usb-3142_Fifine_Microphone-00.mono-fallback \
#         -filter_complex "[1:v]fps=30,scale=320:-1:flags=lanczos[webcam];[0:v][webcam]overlay=x=main_w-overlay_w-10:y=10,fps=30" \
#         -map "[out]" -f nut -c:v rawvideo -
# """
#
# # Команда FFplay для отображения
# ffplay_cmd = "ffplay -vf setpts=0 -window_title 'Stream' -autoexit -"
#
# # Запуск процессов
# ffmpeg_proc = subprocess.Popen(shlex.split(ffmpeg_cmd), stdout=subprocess.PIPE)
# ffplay_proc = subprocess.Popen(shlex.split(ffplay_cmd), stdin=ffmpeg_proc.stdout)
#
# # Ожидание завершения (Ctrl+C для остановки)
# try:
#     ffplay_proc.wait()
#     ffmpeg_proc.wait()
# except KeyboardInterrupt:
#     ffplay_proc.terminate()
#     ffmpeg_proc.terminate()
