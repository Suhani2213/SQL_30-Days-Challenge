create database flight;
use flight;

CREATE TABLE tickets (
    airline_number VARCHAR(10),
    origin VARCHAR(3),
    destination VARCHAR(3),
    oneway_round CHAR(1),
    ticket_count INT
);


INSERT INTO tickets (airline_number, origin, destination, oneway_round, ticket_count)
VALUES
    ('DEF456', 'BOM', 'DEL', 'O', 150),
    ('GHI789', 'DEL', 'BOM', 'R', 50),
    ('JKL012', 'BOM', 'DEL', 'R', 75),
    ('MNO345', 'DEL', 'NYC', 'O', 200),
    ('PQR678', 'NYC', 'DEL', 'O', 180),
    ('STU901', 'NYC', 'DEL', 'R', 60),
    ('ABC123', 'DEL', 'BOM', 'O', 100),
    ('VWX234', 'DEL', 'NYC', 'R', 90);



-- Write a query to find the busiest route along with the total tickets count
-- oneway_round = 'O' -> One Way Trip
-- oneway_round = 'R -> Round Trip
-- Note: DEL -> BOM is different route from BOM -> DEL

select * from tickets;


-- Better way of approaching a solution for such quetion is try first to solve for one way trip
select origin, destination, sum(ticket_count) as ticket
from tickets
group by origin, destination;



with main as (
select origin, destination, oneway_round, ticket_count
from tickets
union all
select destination, origin, oneway_round, ticket_count
from tickets
where oneway_round = 'R'
)
select origin, destination, sum(ticket_count) as ticket
from main
group by origin, destination
order by sum(ticket_count) desc;

-- DEL to NYC has the busiest route