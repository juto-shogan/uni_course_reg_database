-- DML Operations for a Course Management System

-- 1. Registering students for courses (Initial Batch Inserts)
INSERT INTO enrollment (enrollment_id, student_id, offering_id, enrollment_date, grade) VALUES
(13, 1, 7, '2025-03-7', 'A'),
(14, 2, 2, '2025-03-8', 'B'),
(15, 3, 1, '2025-03-9', 'C'),
(16, 4, 1, '2025-03-10', 'B'),
(17, 5, 1, '2025-03-11', 'A');

-- 2. Registering a single student for a course (Example for new registration)
INSERT INTO enrollment (enrollment_id, student_id, offering_id, enrollment_date, grade)
VALUES (18, 6, 2, '2025-03-12', NULL); -- Replace values as needed

-- 3. Dropping a student from a course (Example 1)
DELETE FROM enrollment
WHERE student_id = 3 AND offering_id = 1; -- Replace with desired student_id and offering_id

-- 4. Dropping a student from a course (Example 2)
DELETE FROM enrollment
WHERE student_id = 4 AND offering_id = 1; -- Replace with desired student_id and offering_id

-- 5. Listing all students enrolled in a particular course offering.
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

-- 6. Listing all students in a specific course offering (Alternative/Specific columns)
SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    e.offering_id
FROM
    public.enrollment AS e
INNER JOIN
    public.students AS s ON e.student_id = s.student_id
WHERE
    e.offering_id = 2 -- Replace with desired offering_id
ORDER BY
    s.last_name, s.first_name;

-- 7. Listing all students enrolled in a particular course (across all offerings)
SELECT
    c.course_id,
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
    c.course_id = 1 -- Replace with desired course_id
ORDER BY
    s.last_name, s.first_name;

-- 8. Finding all courses taught by a specific instructor (Detailed output)
SELECT
    i.instructor_id,
    i.first_name,
    i.last_name,
    c.course_id,
    c.course_title,
    co.offering_id,
    co.term,
    co.year
FROM
    public.instructors AS i
INNER JOIN
    public.course_offering AS co ON i.instructor_id = co.instructor_id
INNER JOIN
    public.courses AS c ON co.course_id = c.course_id
WHERE
    i.instructor_id = 1; -- Replace with desired instructor_id

-- 9. Finding all courses taught by a specific instructor (Concise output)
SELECT
    c.course_id,
    c.course_title,
    co.offering_id,
    co.term,
    co.year
FROM
    public.course_offering AS co
INNER JOIN
    public.courses AS c ON co.course_id = c.course_id
WHERE
    co.instructor_id = 1; -- Replace with desired instructor_id

-- 10. Counting students per department (Excluding departments with no students)
SELECT
    d.department_id,
    d.department_name,
    COUNT(DISTINCT s.student_id) AS student_count
FROM
    public.students AS s
INNER JOIN
    public.departments AS d ON s.department_id = d.department_id
GROUP BY
    d.department_id, d.department_name
ORDER BY
    d.department_name;

-- 11. Counting students per department (Including departments with zero students)
SELECT
    d.department_id,
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM
    public.departments AS d
LEFT JOIN
    public.students AS s ON d.department_id = s.department_id
GROUP BY
    d.department_id, d.department_name
ORDER BY
    d.department_name;

-- 12. Identifying courses with available seats (Method 1)
SELECT
    co.offering_id,
    c.course_id,
    c.course_title,
    co.max_seats,
    COUNT(e.enrollment_id) AS enrolled_students,
    (co.max_seats - COUNT(e.enrollment_id)) AS available_seats
FROM
    public.course_offering AS co
INNER JOIN
    public.courses AS c ON co.course_id = c.course_id
LEFT JOIN
    public.enrollment AS e ON co.offering_id = e.offering_id
GROUP BY
    co.offering_id, c.course_id, c.course_title, co.max_seats
HAVING
    (co.max_seats - COUNT(e.enrollment_id)) > 0
ORDER BY
    c.course_title;

-- 13. Identifying courses with available seats (Method 2 - similar to Method 1 but different grouping order)
SELECT
    c.course_id,
    c.course_title,
    co.offering_id,
    co.max_seats,
    COUNT(e.enrollment_id) AS enrolled_students,
    (co.max_seats - COUNT(e.enrollment_id)) AS available_seats
FROM
    public.course_offering AS co
INNER JOIN
    public.courses AS c ON co.course_id = c.course_id
LEFT JOIN
    public.enrollment AS e ON co.offering_id = e.offering_id
GROUP BY
    c.course_id, c.course_title, co.offering_id, co.max_seats
HAVING
    (co.max_seats - COUNT(e.enrollment_id)) > 0
ORDER BY
    c.course_title;