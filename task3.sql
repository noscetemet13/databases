CREATE TABLE students (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    birth_date DATE NOT NULL,
    gender CHAR(1) NOT NULL CHECK(gender = 'M' or gender = 'F'),
    info_about_yourself TEXT
)

CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY,
    able_to_have_remote_lessons BOOLEAN NOT NULL,
    full_name VARCHAR(50) NOT NULL
)

CREATE TABLE lessons (
    lesson_id INT PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    day_of_the_week CHAR(6) NOT NULL CHECK(day_of_the_week = 'MONDAY' or day_of_the_week = 'TUESDAY' or day_of_the_week = 'WEDNESDAY' or day_of_the_week = 'THURSDAY' or day_of_the_week = 'FRIDAY' or day_of_the_week = 'SATURDAY' or day_of_the_week = 'SUNDAY'),
    room_number INT NOT NULL
)

CREATE TABLE studying_students (
    student_id INT,
    lesson_id INT,
    PRIMARY KEY (student_id, lesson_id),
    FOREIGN KEY (student_id) REFERENCES students,
    FOREIGN KEY (lesson_id) REFERENCES lessons
)

CREATE TABLE students_data (
    student_data_id INT PRIMARY KEY ,
    gpa NUMERIC(3,2) NOT NULL CHECK(gpa<=4.00),
    need_for_dorm BOOLEAN NOT NULL,
    additional_info TEXT,
    student_id INT UNIQUE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students
)
CREATE TABLE instructors_data(
    inst_data_id INT PRIMARY KEY,
    instructor_id INT UNIQUE NOT NULL,
    FOREIGN KEY (instructor_id) REFERENCES instructors
)

CREATE TABLE speaking_languages(
    language_id INT PRIMARY KEY,
    language VARCHAR(50) NOT NULL,
    mother_language VARCHAR(50) NOT NULL,
    inst_data_id INT NOT NULL,
    FOREIGN KEY (inst_data_id) REFERENCES instructors_data
)

CREATE TABLE instructor_lessons(
    instructor_id INT,
    lesson_id INT,
    PRIMARY KEY (instructor_id, lesson_id),
    FOREIGN KEY (instructor_id) REFERENCES instructors,
    FOREIGN KEY (lesson_id) REFERENCES lessons
)

CREATE TABLE work_experience(
    work_exp_id INT PRIMARY KEY,
    company VARCHAR(50) NOT NULL,
    job_occupied VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    inst_data_id INT NOT NULL,
    FOREIGN KEY (inst_data_id) REFERENCES instructors_data
)