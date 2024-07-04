def func(x):
    """Prints the input into the terminal

    Parameters
    ----------

    ```
    x : Any 
    ``` 
    `input`


    Examples
    --------
    
    ```
    >>>func(234)
     234
    >>>func("Hello world")
     Hello world
    ```

    """
    print(x)

help(func)


def divide(divisor, divident):
    return divident/divisor

def my_function(x : int, y : int, z : 'int/float'):
    """s
    Returns the sum of z and sum of all numbers from x to y

    Examples
    --------

    ```
    >>> my_function(1, 11, 0)
    55
    >>> my_function(1, 3, 3)
    6
    >>> my_function(5, 10, 12)
    47
    ```
    """
    for i in range(x, y):
        z += i
    return z

my_function()