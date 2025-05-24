import subprocess

# Основная команда захвата с камеры
ffmpeg_cmd = [
    "ffmpeg",
    "-f", "dshow",
    "-video_size", "640x480",
    "-i", "video=HD 720P webcam",
    "-filter_complex",
    # Разделяем поток на 4 копии
    "[0:v]split=4[original][hue][cold][vintage];"
    
    # 1. Оригинал (верхний левый)
    "[original]crop=iw/2:ih/2:0:0[orig];"
        
    # 2. Теплый фильтр (верхний правый)
    "[hue]crop=iw/2:ih/2:ow:0,"
    "hue=s=1.5:h=10[hot];"
        
    # 3. Холодный фильтр (нижний левый)
     "[cold]crop=iw/2:ih/2:0:oh,"
    "colorbalance=rs=-0.3:bs=0.3[cold];"
        
    # 4. Сепия (нижний правый)
    "[vintage]crop=iw/2:ih/2:ow:oh,"
    "colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131[vintage];"
        
    # Собираем мозаику 2x2
    "[orig][hot]hstack[top];"
    "[cold][vintage]hstack[bottom];"
    "[top][bottom]vstack[out]",
        
    "-map", "[out]",
    "-f", "nut",
     "-c:v", "rawvideo",
    "-"
 ]

    # Команда для отображения
ffplay_cmd = [
    "ffplay",
    "-window_title", "4-х канальный просмотр",
    "-vf", "setpts=0",
    "-"
]

    # Запуск FFmpeg и передача в FFplay
ffmpeg_proc = subprocess.Popen(ffmpeg_cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
ffplay_proc = subprocess.Popen(ffplay_cmd, stdin=ffmpeg_proc.stdout)

# Ожидание завершения
ffplay_proc.wait()
ffmpeg_proc.wait()

# #!/usr/bin/env python3
# import subprocess
# import sys
# import time
# from datetime import datetime

# def show_single_webcam():
#     """Просмотр веб-камеры с минимальной задержкой"""
#     cmd = [
#         "ffplay",
#         "-f", "dshow",
#         "-video_size", "640x480",
#         "-framerate", "30",
#         "-fflags", "nobuffer",
#         "-flags", "low_delay",
#         "-probesize", "32",
#         "-analyzeduration", "0",
#         "-i", "video=HD 720P webcam",
#         "-window_title", "Веб-камера"
#     ]
#     try:
#         subprocess.run(cmd, check=True)
#     except Exception as e:
#         print(f"❌ Ошибка: {e}", file=sys.stderr)

# def record_screen_with_webcam(output_file, duration=10):
#     """Запись экрана с синхронизацией"""
#     cmd = [
#         "ffmpeg",
#         # 1. Захват экрана (оптимизировано для 60 FPS)
#         "-f", "gdigrab",
#         "-framerate", "60",
#         "-thread_queue_size", "1024",
#         "-probesize", "32",
#         "-analyzeduration", "0",
#         "-video_size", "1920x1080",
#         "-use_wallclock_as_timestamps", "1",  # Использовать системное время
#         "-i", "desktop",
        
#         # 2. Захват камеры (оптимизировано для 30 FPS)
#         "-f", "dshow",
#         "-video_size", "640x480",
#         "-framerate", "30",
#         "-thread_queue_size", "1024",
#         "-fflags", "nobuffer",
#         "-use_wallclock_as_timestamps", "1",  # Использовать системное время
#         "-flags", "low_delay",
#         "-i", "video=HD 720P webcam",
        
#         # 3. Захват микрофона
#         "-f", "dshow",
#         "-audio_buffer_size", "50",
#         "-i", "audio=Микрофон (5- Fifine Microphone)",
        
#         # 4. Фильтры с коррекцией задержки
#         "-filter_complex",
#         "[0:v]setpts=N/FRAME_RATE/TB[scr];"
#         "[1:v]setpts=N/FRAME_RATE/TB[cam];"
#         "[cam]scale=320:-1[cam_scaled];"
#         "[scr][cam_scaled]overlay=x=main_w-overlay_w-10:y=10[v]",
        
#         # 5. Параметры кодирования
#         "-map", "[v]",
#         "-map", "2:a",
#         "-c:v", "libx264",
#         "-preset", "ultrafast",
#         "-tune", "zerolatency",
#         "-crf", "23",
#         "-g", "60",
#         "-r", "60",
#         "-c:a", "aac",
#         "-b:a", "128k",
#         "-vsync", "1",
#         "-t", str(duration),
#         "-y",
#         output_file
#     ]
    
#     try:
#         print(f"⏺ Начата запись...")
#         start_time = time.time()
#         subprocess.run(cmd, check=True)
#         end_time = time.time()
#         print(f"✅ Успешно записано за {end_time-start_time:.1f} сек")
#     except Exception as e:
#         print(f"❌ Ошибка записи: {str(e)[:100]}", file=sys.stderr)

# def reverse_and_rotate_video(input_file, output_file):
#     """Реверс и поворот видео"""
#     cmd = [
#         "ffmpeg",
#         "-i", input_file,
#         "-vf", "transpose=1,reverse",
#         "-af", "areverse",
#         "-preset", "fast",
#         "-y",
#         output_file
#     ]
#     try:
#         print("🔄 Обработка видео...")
#         subprocess.run(cmd, check=True)
#         print(f"✅ Результат сохранён как {output_file}")
#     except Exception as e:
#         print(f"❌ Ошибка: {str(e)[:100]}", file=sys.stderr)

# def main_menu():
#     """Главное меню"""
#     while True:
#         print("\n" + "="*50)
#         print(" FFmpeg Dual-Recorder ".center(50))
#         print("="*50)
#         print("1. Просмотр камеры")
#         print("2. Запись экрана + камеры")
#         print("3. Реверс видео")
#         print("4. Выход")
        
#         choice = input("Выберите действие (1-4): ").strip()
        
#         if choice == "1":
#             show_single_webcam()
#         elif choice == "2":
#             duration = int(input("Длительность записи (секунд): "))
#             output_file = f"input.mp4"
#             record_screen_with_webcam(output_file, duration)
#         elif choice == "3":
#             input_file = "input.mp4"
#             output_file = f"reversed_input.mp4"
#             reverse_and_rotate_video(input_file, output_file)
#         elif choice == "4":
#             print("Завершение работы...")
#             break
#         else:
#             print("Некорректный ввод!")

# if __name__ == "__main__":
#     main_menu()