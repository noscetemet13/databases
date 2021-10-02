--1a
SELECT * FROM course WHERE credits>3;
--1b
SELECT * FROM classroom WHERE building='Watson' OR building='Packard';
--1c
SELECT * FROM course WHERE dept_name='Comp. Sci.';
--1d
SELECT course.course_id, title, dept_name, credits FROM course, takes WHERE takes.course_id=course.course_id AND semester='Fall';
--1e
SELECT * FROM student WHERE tot_cred>45 AND tot_cred<90;
--1f
SELECT * FROM student WHERE name LIKE '%a' OR name LIKE '%e' OR name LIKE '%i' OR name LIKE '%o' OR name LIKE '%u';
--1g
SELECT course.course_id, title, dept_name, credits, prereq_id FROM course, prereq WHERE course.course_id=prereq.course_id AND prereq_id='CS-101';


--2a
SELECT dept_name, round(avg(salary)) as average_salary FROM instructor GROUP BY dept_name ORDER BY average_salary asc;
--2b
SELECT building, cnt FROM (SELECT building, COUNT(*) as cnt FROM section GROUP BY building) as sub WHERE cnt=(SELECT max(cnt) FROM (SELECT building, COUNT(*) as cnt FROM section GROUP BY building) as sub);
--2c
SELECT dept_name, cnt FROM (SELECT dept_name, COUNT(*) as cnt FROM course GROUP BY dept_name) as sub WHERE cnt=(SELECT min(cnt) FROM (SELECT dept_name, COUNT(*) as cnt FROM course GROUP BY dept_name) as sub);
--2d
SELECT  takes.id, student.name FROM course, takes, student WHERE takes.course_id = course.course_id AND takes.id = student.id AND course.dept_name = 'Comp. Sci.' GROUP BY student.name, takes.id HAVING COUNT(takes.course_id) > 3;
--2e
SELECT * FROM instructor WHERE dept_name='Biology' OR dept_name='Philosophy' OR dept_name='Music';
--2f
SELECT instructor.id, instructor.name, instructor.dept_name FROM instructor, teaches WHERE instructor.id = teaches.id AND teaches.year = 2018 AND instructor.name NOT IN ( SELECT instructor.name FROM instructor, teaches WHERE instructor.id = teaches.id AND teaches.year = 2017);


--3a
SELECT student.id, name, course.course_id, course.title, takes.grade FROM takes, course, student WHERE takes.course_id = course.course_id AND takes.id = student.id AND course.dept_name = 'Comp. Sci.' AND (takes.grade = 'A' OR takes.grade = 'A-') ORDER BY name;
--3b
SELECT instructor.id, instructor.name, instructor.dept_name, student.id, student.name, takes.course_id, takes.grade FROM instructor, advisor, student, takes WHERE instructor.id = advisor.i_id AND student.id = advisor.s_id AND takes.id = student.id AND (takes.grade = 'B-' OR takes.grade = 'C+' OR takes.grade = 'C' OR takes.grade = 'C-' OR takes.grade = 'F');
--3c
SELECT department.dept_name, department.building, student.id, student.name, takes.course_id, takes.grade FROM student, takes, department WHERE student.id = takes.id AND department.dept_name = student.dept_name AND department.dept_name NOT IN (SELECT department.dept_name FROM student, takes, department WHERE student.id = takes.id AND department.dept_name = student.dept_name AND (takes.grade = 'F' OR takes.grade = 'C'));
--3d
SELECT instructor.name, takes.course_id, takes.id as student_id, takes.grade FROM instructor, course, takes, advisor WHERE instructor.id = advisor.i_id AND advisor.s_id = takes.id AND course.course_id = takes.course_id AND instructor.name NOT IN (SELECT instructor.name FROM instructor, course, takes, advisor WHERE instructor.id = advisor.i_id AND advisor.s_id = takes.id AND course.course_id = takes.course_id AND takes.grade IN ('A'));
--3e
SELECT course.course_id, course.title, course.dept_name, time_slot.day, time_slot.start_hr, time_slot.start_min, time_slot.end_hr, time_slot.end_min FROM course, time_slot, section WHERE time_slot.time_slot_id = section.time_slot_id AND course.course_id = section.course_id AND ((time_slot.end_hr <= 12 AND time_slot.end_min <= 59) OR (time_slot.end_hr = 13 AND time_slot.end_min = 0)) ORDER BY end_hr;