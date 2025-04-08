import robot
from pathlib import Path


'''
python runner.py
'''


robot_options = [
    '--loglevel', 'trace',
    '--outputdir', './out',
]

robot_suites = [
    './robotframework/suites/prihlaseni_uzivatele.robot',
    './robotframework/suites/kosik_pridani_produktu.robot'
]

exit_code = robot.run(robot_options + robot_suites)

