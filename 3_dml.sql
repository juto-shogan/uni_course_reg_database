-- Registering students for courses.
INSERT INTO enrollment (enrollment_id, student_id, offering_id, enrollment_date, grade) VALUES
(13, 1, 7, '2025-03-7', 'A'),
(14, 2, 2, '2025-03-8', 'B'),
(15, 3, 1, '2025-03-9', 'C'),
(16, 4, 1, '2025-03-10', 'B'),
(17, 5, 1, '2025-03-11', 'A');

SELECT * FROM enrollment;

-- Listing all students enrolled in a particular course offering.
SELECT
    e.offering_id,
    co.course_id,
    c.course_title,
    s.student_id,
    s.first_name,
    s.last_name
FROM
    public.enrollment AS e
INNER JOIN
    public.course_offering AS co ON e.offering_id = co.offering_id
INNER JOIN
    public.courses AS c ON co.course_id = c.course_id
INNER JOIN
    public.students AS s ON e.student_id = s.student_id
WHERE
    e.offering_id = 1 
ORDER BY
    s.last_name, s.first_name;

-- Listing all students enrolled in a particular course.

-- Finding all courses taught by a specific instructor.

-- Calculating the number of students in each department.

-- Identifying courses with available seats.

-- Dropping a student from a course.

-- Registering a student for a course

-- Listing all students in a specific course offering

-- Finding all courses taught by a specific instructor

-- Counting students per department

-- Identifying courses with available seats

-- Dropping a student from a course: