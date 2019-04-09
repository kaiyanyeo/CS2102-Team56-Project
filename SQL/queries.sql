--Get Number of postings by each employer
select count(*) 
from appuser.employer e1 left join employerAction.posts p1 on e1.employerUserName = p1.employerUserName 
group by e1.employerUserName

--------------------------------------------------------------------------------------------------------------
--Get Number of Jobs done by the Employee in the past
select count(*)
from appuser.employee e1 left join employeeAction.history h1 on e1.employeeUserName = h1.employeeUserName
group by e1.employeeUserName

-------------------------------------------------------------------------------------------------------------
--Get user with the most task at hand right for each category
select c1.employeeUserName, categoryName, count(*) 
from  (appuser.employee e1 left join taskAction.assigns a1 on e1.employeeUserName = a1.employeeUserName as c1) natural join taskAction.category c2
group by employeeUserName, categoryName 