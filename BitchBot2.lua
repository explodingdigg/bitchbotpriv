local COLOR = 1
local COLOR1 = 2
local COLOR2 = 3
local COMBOBOX = 4
local TOGGLE = 5
local KEYBIND = 6
local DROPBOX = 7
local COLORPICKER = 8
local DOUBLE_COLORPICKERS = 9
local SLIDER = 10
local BUTTON = 11
local LIST = 12
local IMAGE = 13
local TEXTBOX = 14 -- menu type enums and shit

if not BBOT then
	BBOT = { username = "dev" }
end
local menu
assert(getgenv().v2 == nil)
getgenv().v2 = true

local MenuName = isfile("bitchbot/menuname.txt") and readfile("bitchbot/menuname.txt") or nil
local loadstart = tick()
local Nate = isfile("cole.mak")

local customChatSpam = {}
local customKillSay = {}
local e = 2.718281828459045
local placeholderImage = "iVBORw0KGgoAAAANSUhEUgAAAJYAAACWCAYAAAA8AXHiAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAJOgAACToAYJjBRwAADAPSURBVHhe7Z0HeFRV+sZDCyEJCQRICJA6k4plddddXf/KLrgurg1EXcXdZV0bVlCqDRQVAQstNKVJ0QVcAelIDz0UaSGBQChJII10Orz/9ztzJ5kk00lC2vs833NTZs69c85vvvOdc8/5rgvqVa9KUD1Y9aoU1YNVr0pRPVj1qhTVg1WvSlE9WPWqFNWDZUaFubk4sf8g9q5egw2zv8eKid/g5y9GY9HIr7FkzASsmjwVWxcsxMFNsUhPPqG9q16mqrNgpRxJwtKxEzFhQD+8fV8nPOzqiXtdXPBMx2gM/HMnjHm6B/7bsxfWvPk24t4fggOEKjFmMo5OnoKjM2ZiPy1u5iys/m425nw5FuMHD8Lc0ePx/Vdj8MOnIzC93yDsWb5KO1vdU50Ba93MOfj6tVfRw8sP0QToWdpnLk0wr4k3dvkG4Pzv7wVuuwvwaosrnn4436w1Cpq1Qp57a+TymOvmg5ymLXHOlcb35DRqjtwGHshzcaM1Rl7zNii6615cffFVXKV3w4qVSN2zGz9O+w7zYyZh8aRv8MPQYSjKy9euqHar1oKVknAEE/v2RTf3VriTEA12aYiFbq2Q7BcMhEYDQZG4FBCOwvZ65LXTI9svBFn+ocji72LZ9liHsBJjGVm+wchq2R5ZhDPL1RvZLk2Rw/MW/t+fceWjT4E9e7Bl7TosmDgF80d9ja3z/6ddbe1TrQIrKzUVY3u/hD8QpB60mU1a4GRbghQSjStB4cgPDMO5gDBkdtAjM0AsDFkClTloKsI06LJ8g5Dl3RaZDT0JmwsK/tgJ1whXXkoK5o2biAXsPncvX6l9itqhWgHWopgYPNTAHX9lo81hV5VPcBASicLA8BKQpIEFpDJmgEtnHozKMCNonr7I4vXmEvDrY8cjMy0NcyQ+o2e7dvWq9slqrmosWNevX8eInj0Rxcb5xMWVXVwQEByBAvFEbMAMwmQOJHNW5XAZTTxaW3bBjOky+TkK7+sCbNyIJf9biFlDPsHp+MPap615qnFgFZ7LwcAuD+IO8U5uLRkrRTBWki6HMLXXKaDEQ8nPcjQHkjkTuLL9bwJcRhNP1oaerJEXchp6ADETsWfHTswcNhzxGzZpn77mqMaAdfXSZfTv1Bl3Eajl7EakqytgzJROD5XBhjF0d6WtxsFlNHpP6SolHrv23hAc3r8fUwa8h1P7D2q1Uf1VI8D6rNuTuI2VvFgDSuKS9A46BZUCS0Big5QFS8wpuG5Gt2jWeE3e/ioWwyfDsW1jLL7+9wu4cvGiVjPVV9UarFXTp6kYanITbwVUXmAJUBkmVhlw3ZSYy5JJN9m8LT1YQ2DpUsybMRsz3x6g1VL1VLUE60J+Ph7z9MHzhKooKBzntS6vLFCmVrs9V4llNvZCQbsQXE5Oxif/7IWk7XFarVUvVTuwZg8dio4EKtanA71URAk0dlhdgSvbP1SNIvHG21i/ZRNGP/Mvrfaqj6oVWE/4+OFlqTDp9gQUdnvmALJmFQ6XTAlUR7ike/Rui9wmzXHt1Em81+0JZJ86rdXkzVe1ACtx53YVSy1r0RYIjUC6xFIaIObgsWWVBpfRyjbyzbR2/DzyZRw+AtPHjMfqWbO0Wr25uulgxbz4sroFk0WYCmhnBSrjUQPEHDy2zCZcclTQ8NguFBltg5DpF4hs30DktglAXusOKPBph0K/IBS2D0Eh4ZL7ioX+wSjk//Nb+COvZTvk+HDU5tMeWa06GGbU24ZUPXzivZr64PKdf8C+LZsx7C+PaLV783RTwXpJF6kCdEMspcOZDqE4y6PyWJUEl3grgUgBRHAuEaprt98DdHoYebQDd3TC6oi78EPI7YgJvxXjwm/HpPDfYcpt92Lq7f+Habf8EdPCf4u5tNW3/R8O3PNXFHR9Cuj6JC7d8wAKI+9APsE759UWma0InF9wlYEmYOe4NMaF48fRt+tDWi3fHN00sLq4NsOXjbwIVTjOBBiAEjMLl5N8Qlc6YQnizCJF7oSFAHc1xUJBGhmSDTe89dj2B/+jBGv9MaEIUOwbuFiHD9+DJe067SmQlpCYiKWz/sRcz/6DIsHD8XCp3phwe33Ialzd+DRZ3H+zvuQR7iyvH2R1YYesQogU4H9gX3o0/kBnM/LM1xsFavKwbpYUKhuxyz28sfVYEKlgWRqFQGXCvw5LM9r3R6IvgM5dz+AWcFReM27HQY+0g2zR41CekaGdlUVr8TkZPz01VisfHMQfv79A8h7/J+49Cd6RX6OrOaEjF2sOSgqxNg1qrhrzDi898TfcfrAIe2qqk5VClZ+RqZaZLeTLrswKByprIA0QnDWxGNZg8ueLjG9fSiH40G4yuP5uztjakAEerq2wEcv/geJe/dpV1L12hobi9UffoLl9/0NF3o8j6I/dMY5bz8Vm1WKF5O4y8UD6P0Gvnh7IBI2btaupGpUZWDlpp1FJKE6JF4kUEeo9IQqDKm0NAWT855LdXcEKadtgPJOcZF3oZdLE7zZ9a/YF1u1FWqPNv+yBuv7DEJ8lydxhfFZjnSVHAhUBmBZbj7Ak89iwmcjcHDdOu0KKl9VAlZ+RpaC6gg/aA7hSCVEacpK4DqjYHLcc0mXl9s2EOh4J5YFd0QXnmd037e1M1dvZV+7grWfjMKuLj1w9bHncE4A44CiogHLcm8DPNYDEz75HAmbquaLVulgXSwoUt3fIX96lEB2f5qHMoDlPFziubLp/RB2K1YFdcQfeY7pn36qnbVm6TJtw9cx2P/Xp3H5b08jq0VbQ6BvBhJnTcH1VE+MeLMfTh+s/Jir0sGSQH0HY6q8YqiMdgNw8f/XaIlRd6ITy//ixZe0s9VsFdE2fjQcpx/5B4rueQCZHq0q1HupbvHVNzHob91xIb/AcNJKUqWC1dnVTY3+Cjj6MwTqZa08XCk0w/SDebhyO4TgetRv8KZLMzyrj1ArSWubzuTmIPZfr+LS31/GOZkqac0A3wwozlhWAwb0Y8fjtc5dtLNVjioNrJd0UWqe6jKhSgkkMDTH4BKYSuASqEBvtSkgUq3N2rZsqXam2qtdi5ci+fF/c3TbBRmyEcMMKA6bcSri0EG83rmzdqaKV6WAFfPSy/g3L/56SBROM7hOITCpDsJl6BYNYGUIVAS1j0tTPBPAuKoOKTU7E5u/mojzX3ylFv2ZhcVR0+DKPxSPoZ0e1M5UsapwsI7s3I67edFXQjriZIdwnCIgKU7CJZ4rl79nBUeqJcmzPvxQO0vdkKwUHf0GR7izZiHTpZF5SG7Acl1csWvrZvzyw/faGStOFQ6WrFJIC4wgFAJVOE6qY3m40szCJVAZABP4LrCcbX4hqsyUGrxjxRkJVF+/3geYPZtQNVBexhwcN2Jyb/Ha7+/Fl+8MRt6Zs9qZK0YVClYPH18s8m6HLAJhAKoErtOEyl64Utn1XQsOw1wPX7Xy4eole+7c1R4pT/V6X3oqgcqlUqAymqyKwKiv8NajFbsiosLAmj1kqFqkdyU4il1gWDFUjsKVwt8REoYxDPy7enprpdcdXb5wAWPefEeDqnI8VSlj+bJZI3//fox67EntKm5cFQKWrFG/hRdXFBpt8FQqtipvtuBK6aAHGE+NbOiFHm38tNLrjgSqsW/102KqKoDKaO30KGjWEgsWL8Kpvfu1q7kxVQhYj3u2xLrWATgTFI4TgQTIAlhiluCSe4fXCNWYxt54oo5CNa5P/6qHSjNJZIK3B6LvI49qV3RjumGwVk6fpqYWLoZE4wS9zkmCZQuuEzRTuASs8yHhmMOYqqunl1Zy3ZFANb7vAA2qyo2pLJrWJWbu3ImpAwdrV+a8bhgs6QIzgiMIk14BI2DZA5fRc8k8Vw7B2tgmUAXqdU2Xzp9HzDsDge9ujqcyNUnjdEnXEcN7v6VdnfO6oZYc3u1JjHdtgcygCCTTWyU7CJe8VmbYJdiXKYW6NvoTqCb0G1SxUMm9xRtIzSS5IxC7Ee8+eGNLm50GS3Ip/IYwnNdFI4mxVTIBEq9lDi5LwbzYeXahUk5KfIJWct3QpaLzmNj/XQ2qiun+strqkK+PVGvtzf3fXstzaYIfZs5E5nHn86s6DdaAP3XBvOZ+SGU3eJxgHXMQLvFS1wjVc6zUOUOGaqXWDV0qKsKkge9VMFShuKKLwjx3d1zrPRhZ7j5mX2ePZbFdMXos3u3WQ7tix+UUWJJKSOKhi/poHGN8JGCVhyvMIlwSX2UHRmC2py96BYdppdYNXSRUkwd9QKi+Q7pLQ2SyXm50aYxAdTk0Ej81aYwzPMeUzg8Df+luWPZs5vU2jaDnsn1/otc6te+A4cIdlFNgDeryIH4k1adNoCoPl07FXSrOKgPXaYKVGhChttLXJSmoBn9YDFUW66PUhlhzjWzDjFAtJFRJ53LVec5dvYLlv+uMQtazs8lN5IY3Rn6B97o/pcp0VA63rKx/+i2BKNJH4WiQHkkc2TkGl6ELfJhlxK1crpVa+3WxsBBT3hsCzCwNVbnd1mYa2ZIZoVpkApVRP8+chdwnnkeWLBY08157LNelEeZMmODUfUSHwRrZ81lMd2uF08HhBCtM2bEO9sOVzhHkfO+2eCnyVq3E2i/Z8vbtBx9pUDUoB1UJXGxQO+Eqhsq1CY5ll4bKqNH3Pgh0edTpZc5ZHr7AnO/xIUf/jsphsG6lp8nRRSKJnieJUIk5AldRSFSd6gIVVB9+TKhmmvVUZU3BZSOroBGqxVagEqXl5mDNXZ2RK6NEZ7pEvqeQg4CR/R3PxeVQCy+OicEQl6ZI0xm8VSm4+LMluE4QrmTCdS44Ep+4eGBi79e0Emu3LhQUYOqQYcAM+6AymjXPZS9URo3u9SLQvZdhe5mZ8mxaE28UzP8Rk/oP1Eq0Tw6B9UiDZtjbLgRJHMkl0AQmI1iW4BKw5CgjwTTGZLKsuC5IQTX0UwXVWX7mDDMAWTKVUdAMXAaoIvCznVAZNS3styhkec4E8tKN4tEe+OCZ57TS7JPdrZyVkoaurKD8sCgkEpAjjsDFv2XzW/aeiyvmjRiplVh7daEgH9M+/oxQzVBQGbPaSEIScyCZs7JwGT3Vz00dg0o0acBgXO/+L+e8lpp6aIBFY8Ygec9erUTbshusca+8jG+btsSJkHAkEigByxpcSSZwJdPSGLTfXge8lSwhmjZsuAZVg5JUSZo5A1expxKoyoz+7NWEkNtRRFCc8lrNJYj/L4Y4EMTb3dLyZCyBJpHQCFimcMnPpnAVx18aXOnBERjZwBPTBg7SSqudupCXjxmffF7OU5U1h+Bqp8clDpaWNnUtN6XgiL5+mXHto885NWkqOb8uRd6Oob1f10qzLbvASkk8giekovSRiA/WI8FBuAr10bV+JKig+nSEguoMP2s6P7+lpG9i9sAlUF1knS9lTJV07sbSEclDVKbrbke+jxP3Edkd5nHQtmz0GBzetMVQoA3Z1dqT+/bFRNcWOM5uMJ4AiR22E65TtPkebTC0W3ettNqn84Rq5vBRbDkDVBmsA2OyEmfhUp6KUC1TUDnvqUw14qlngD8/4lQKJdUdzpyNYc+yDDtkF1g93H2wq12wAuewZvbAdTRQj3y6cXkS19EdO7XSapcksdmsz7/QoGpQDFVx0hIn4DJ6qoqESrR17Trs/v1fkOPd1iw81kxGh9cf7oYPuz2tlWZddoH1e4KRHR6NeI4GjWDZgku6wWPiuVixEp/VRp3PzcXskV8SqumlPFVZcwQuI1TLZUqhAqEyaljYbbgUEq0W9ZkDyKKxOyxwaYwxQ4bCnqQGNlt8/cw56Mdv4qnQcBwgKAomE7MGVwoD98nsQie8XvsmRIsI1ZxRX9uEymj2wGWEakUlQSX67PkXgAefcOo2T25THxwaOx4Lh9ND25BNsMa+/iq+a+aDI4yvDhGWg7RycBG4snDJXFcOK0mC/tO1bBGfgurL0cA0+6AymjW4MuhBLjBsWFnB3V9ZHdq7F6uj70a+E3Naklce4ybig7/bjrNsgvV3Lz9s9w9S3aCAZQ2uBLpyU7hSg8Pxu1rWDRbl5KoHihugKh9T2TLJ61UWrgx/HS6ERmClmlKo/GS0HwRG4CLP6+iclpqFf+QJvP+Q7YGYzVaXSc2MsCjsD9bhoANwJYeE4X9evhjWw/lViNVNhYTqh9HjcN3O7s+SmXquYqjcbmyeyhEN7c4A/L6HDKnCy8Bjy867NMPQ99/VSrIsq2ClHknCM6zAFH049hOq/UF2wEVLIGApjMk+dHHFknExWmk1W0XncvDDmPG4PnUa0lgnZ/kZnc0/L6ZyqWpQrXJrWmVQib4bNQrJv++CnDYBZuGxaBLAN/bCj/3fxZEd1h8OZRWsZWPZnxKO46Fh9Fh6HKDZBRf/f47xwkNsgMK8fK20mitZij1v3ARcmzpVQSWTnypdpUDiJFzp7IbO6yOwmlAdq4Luz1SZWVmYwZFhoROTpTnubZA4YhTmvm89849VsCYN6Idv3FqoLu4Au0IBy1640kIiVJrImq7Cc+cwf/xEBVUqP88ZAUozZ+ESqIp0EfhFQVV1nspU/RgvXeZ1OBxnebXF9bEx+PiVl7WSzMtqy/e//09Y3ao9QQrDrwTJXrgkcN/YpgNeruGrRAWqBTGTCdW3CioByZhd0Fm4jFCtaVb1nspUA267G7jjXnUf0BxAliyTo0kMfA/97/2zVpJ5WQWru0crNW3wK4PUvTRTuFTXaAYuASuJgfssdx/E9HlTK6nmqYBQ/ThxSjmojGDJ0VG4iqFSMdXNg0o09LXeuPbHvzh8e0dyauGBv2HAX6zneLAK1n3i+jki3MuK+5Vey164ToaE4zMXd/z4+QitpJqlguxs/DjpG1xloH7apQHBKUmwawqXI57L1FPdbKhE0z4ahvhb7kGugyND6TovE8Z+ct/RiqyC9TjBSmZl7JGuUEFlHi7TbvEgX3Oa73mN7927eq1WUs1RQRahmjwVV7/9llA1RFpgOCR15dmAELNwydEWXNUNKtHWZSuwJCAKBfRA5gCyaBwZnqfT+Ki/9Yc0WATr/IWLKpFaEofDewiMNbhMYy7xWGf0UWrGPTtNtk/WHAlUP30zjVB9Q6gk5WVJot1UJ+EyQrW2GkElSjt9GhP8g1Hk6K0dglXUyAuj+/VFfmaWVlp5WQTr9NFjeJeVG894aa+ARdtrAtceHmVuyxxcGQRLEvvXJEn399O303BFeaoGhMqYbLcELoPnKkkRbgsuI1TrbnKgbknvt/LHZYKVZQ4gS8YvTKGrD777z0s4ttfyUmWLrX9o6w58zgo+EKLHbkJjDi7xXKZwGbvFrLDoGrUMWXmqqTPoqaaW6v7S6KGchqu9DoUClTuhyq5+UIle8vDBVXaFDoFFK2jmg4WvvI49K1ZrJZWXxdbfvmQ5xjVyxT7CtJvgWILL4LlMvBZfm8oKrSn3CAuysrBo6kx6KlOoDKkrDUCVThFuD1wCVYE+Auurqacy6p8uzQAntuHnN2uFVa+/jQ1zftBKKi+Lrb9hwU/4poEb9mkea5cDcB0LDcP9NQCsAsYIi2Z8h8vs/k4SqlTZ9MEYogQsJ+BqF6Kg2lDNoRL1dGkOhEQ5DpZbK2wY8C5WMR61JIutv2bWD5jRxAO7Q8KLoZLjHitwydSDgJXIuOyBag6WBJ6S3+DyN9/iBLt8WYmhcqEKNBbhkq7RFC6BqQQuBZUuHBuk+6vmUImeaegF6G91GKw8grXpvSFYNmaCVlJ5WQHre8xo7IE9IRHYSYiM3aFNuBj0Ho8yPDewukqgWvrdbFwkVMfpqVIYE0nKyuJEuwKNnXAZn/ljhGpjDYFK9KSLJxB2G8FybDWpeKyNAz/A8rFOgLVh/k+Y3tgduwlMHL/NdsMllf6bO6vtcmQF1ey5CqpjhOpUYAQkKW8K4XAWrjQ2TH4Ng0rUzcUVCI12IsZqjV/6DMDqb6ZrJZWXxdbfyuD9mwZNCRGhYiXaC9de6RLuuEutk69ukmdSL5vzPS5O+YZQNVJQFWcYJCCOwWWIuVLbsWvQRSLW3Y1Q3Zwbys7qEWmj4EiHwSrwaIOfe72ITd/P00oqL4utf2DrdsQ0bIRdDGh3EJod7C5swiVg8bUnWemdGzTRSqoeEqhWzP0vLpmBqjRcutJwlQNLTHveT7tg5IVGYJN7sxoHlehRAYtfDjXd4ABchR6tMbvHs9i3xvKdFYtgnTyShFE88W4G4jsIzY4gPXYSmhK4Qi16rhOMN3q0aKmVdPOloOK367yCytD9lYXKAJYc7YMrld1fXmg4Yj1qJlSif3DQgg56w1Z+gcYeuPj6IrfWGNfzaZzcf1ArqbwsglV44QKGCFi6MGwnOObhKu+5dtOOtg3C64GByDh5Sivt5imPUK3873xcIFRJhOpkkPYAqQ6loTIHV+knZ5hCxe6Pnkq6v+M1FKqM1DT0dWmMqxpY9sIlr7nMGGvI44+i0MpntwiW6C2CtZfxw9ZQvRW4TD0XPRYt3rcDht9xO3YvXamVdHOUl5GBVfN+pKeagqPs/hRUgZIITgPIFlz0WmWf+SNQ5YYypqKnqqlQiXat/AXDmzRXmyoUVHbCJf+/5t4aL3ax/nRWq2C9QLAO6gWscItwxSm4TD1XGPb7B+L7e/+MuUM/1kqqeuWlZ2D1gv8VQ3UiRI9kgUagchKu06xUgWpzDe7+jPr+s88xu7kfCgiWcbNsMVz88liCSza6QheN7u15tCKrYL3q5Y+ksHBsYZy1jXBtM4FruxW4fmVQu+WxJ/Bl71e0kqpWAtWaH39C0eQpSGT3d1weyUJvY0hZ6Rhc6pk/EnOxImWf5BaPmjf6M6ev33oDG1oFIk+CdxOwiuFqT7AEsLJgtQkCejyDh92sP/PIKlhv3Hs/UsIYS7BBthIu8VymcMlI0Rxccf4ByHj5FfRs20ErqeqkoPrfQhTRUxmhUlkFBSRWmDNwneS395x4bdX91Zx5Kmv6d3i0+nznynisUnCZ8VrnfINw9sGH8frd92glmZdVsL7o9w72dQhELLuRrfRQ4rUMcIUqj7XdAly7AkNxLPoWPMtGrUoJVGt/WozCyZORoEFlTP6mEu2awqWBZQuuE+1Ywez+ttXwmKqsVMpO/S1qb6M5sMQUXGUS7eb7hWDjb+7GmLf7aCWZl1WwFnw1Hiu8WxGmMGymx9piAtd2wiXzWwLXdg2unYRrl4JLj/2eLTHs6SdxjqOPqlDe2XSsXfQzCghVPIfRxwiL6VMzzMJFcErBVQYsgSqbo7/aBlVBbi66C1iBEQZ4rJj835jFWQL3C77BGN8+GEvIhjVZBet4QiImNWiEbQIV4ZJYqzRcOnosA1w72Fcb4YojWHtb+WHpv1/AfAaJlS0F1eKlKJg0GYcJVRKvwZgi3CxcAg0rzBpcBk9FqDxrF1SiJWNj8LmLGy7x89oCS0zBxW5RwALteUKZknBUK828rIIl6s9CtgtU4rXMwlXiueTWjxGunb7tkfHxMPS5/z6tpMqRQLXuZ0JFT3VQg8o08ZstuCRNeNln/pxozwpl97ddoMqpHTGVqT56sgdWe/oycC8PkSVTABIuBNmXp9/mK95q2R5HwsOxISTUClz0XGXh4vHYb36LV+7ppJVU8colVOuXLCNUkxRUkhHniEBFkGzBpR6FJ3CxGzd9WlkyocrURWBHLQrUy0oe43dBYJHUSVZirLJ2jnbCNxA9vGw/WtkmWB/3fgXHORLcwKB8E4/m4ZLpiNJwxYVEIK6JF74bPAiJsVu10ipOuenp2ECo8gjVASNUPLfKdOMIXOz6jHAdN4WqFnoqkaSUelI8Dgc2GQRLzF648ll/C9188PXrr2qlWZZNsJZOm4XlzVtiU1AENnJ0aA2uUp6LDbWjVTucmTgFQ56quMfui8RTbVy2ArmTJmE/R38JhErSggtYjsJl7BaPd2Al68Kxo3kzJNdSTyWKeeM1zGjSEgX88stOIpXxxg645CFSV1hXg/klXjdzrlaaZdnuLKnPSPgmwrOJ8cvGEPs91/Z2wUju1AVv//VvWkk3rtyzZ7Fp+UpCNRH7+CEPEyqVPknMSbiSWGkZukjEMaaqzVCJ7mZbysI+yR8vMBnNFlzyP4RE40474iuRXa96x9sfCeERWE+INrEhNjJgtwoX4RO4drDRt7m4Yum4sdi1cKlWmvMSqGJXrkaOCVTGJCQOwcVvqylUZ/Xstpu713qoEnfEGbpB9j5GkEzNGlwqvvILRjd3H60067ILrOFvvIljDN4FrA3iuRyAa2ubdiiMmYhBXR/WSnNOAtXmlb8oqPYSqoMmUNmCS2AqC5ck3ZUc9ALVrlre/Rk1pFt3LPZorW7jWExZSbjKQiUjwkIObGY2boFJfftqpVmXXWAdjU/EnEaNsF66QoKzgY1qhCvWFC424pZgk5iLMCrP5e6N8UM+Bq5d00p0TALVllVrkD1pgoLqEM8vO65lS38psORIgOyBK5GVeJbdX12BShQl3iok0rBT2wJYYmXhkr/J+2R3e0qi9fkro+wCSzSQQfIuvQEqgWujCVybrcHFmGurZyucW7wEwx97XCvNfuWcOYutv6xD9sSJ2MUPtp8DiEMEw5iAxGG4aEdYUWn6SOypQ1DJ42a+buCB86wbtUvbAbiyafn8mzwH3F7Z/cqPX3gBp3R6rGYXp7yWDbjkpnVxtxgUjAMRt2Dky7aHqabKOXMG29YKVBMUVAdYpspwE6hTQFmFi5VhDi7xVGns/hRUtXRKwZxuYf0VcKSeKUBpZi9c0g3ObeqDsTaSrZnKbrBOnTyNOQ0b4Bc2zhp6obJwbSgDl9y0NoUr1s0duRs2Yuw/e2klWpdAtWPdBmRNmIjt9Jb7WVbJbmv74Cr7zJ/DrMgUQrVXRn91CKr/jhih8sHKdEG6TKuUgctW/nnZ1PpXgpnlwH1f+30b1b+ZDw6FR2ING3ltObgksLcM17agUPzasSPG9x2slWZZ0v3tWL8RmRMmYAeh+pWxncoTEWy6ld8xuOJZgakCFUd/J+oQVCLxVnL7xtRb2QuXrHE/7heErg3dtdLsk0NgTRs9FvHt22M1G2odwXEUro1unriyZxdGPP6EVmJ55aadxc4NmxRU2wjVXpZr3LMocJXKbkM7aAdch1g5p8Mi8Ktn3YNqQu/X8LmLBy6x/lSm5jJQGc0cXDKBeolAfkJvtyjG8uZUc3IILNFw0r9RT6gIiyW4JObaYg4u/n+LpxfWrlqFM2ZGF9L9xW3ajPQJMYSqgYLKuPPHEbhUjKXZQVbYKXqqfTJPVcegEqmRoNy+MYHIkpmDS+a8VBkOyuF3DHnyGaSFh2EVwbENFwP5MnBtbtUWGV9/hS97Pq+VaJBAtSt2C9JjYrCFH2QXX1t2z6KA5QhcpaGq+WnBHdWLkbdikaxrZ9CuAnU7zAiXeKtCequ5bi0x8rmeWon2y2Gw8i9fwVQ2/C8cHa7RESxH4eL/1/L92SdPYOFno1SZCqrNhIrdX6xLI7WXsWRzhv1wmcZc+1lBJ/WRCqoTdRCquJXLDTudZd6qTMBuyxSEErQHR6qVEHY97quMHPdx1LudH8SZyAisptdao9MruNYSnHX8vRguBtyb2MBm4SIAu2+5DbGr1uDotu34dUcczrD728SYSlZFWN0QawdcAtUJeqr9dRQqkXRfchvGUsBuzQSsXHq55Z6+GNjlQa1Ex+QUWKkZmfiBF76KDbmWXqsELh4Jj024+LdNzX2QOmY0fj0QT6gmYAOhknuLxvXzlvYsytEYb5mDa29AqILqQB2Gqhfr5QfPNijisWyiXXtMPBxCo3AX27gwJ0cr1TE5BZbo3U5dcDY6EqtCbMAVRLj493JwEaJ1Lo1xYuRIrG/QSEFVdltZ+d3W1uH6NUCH4/pwQuVR50Z/Rs0ZMhT/kO4rNMKQt4uexxG4xFvl8T2LCWb/P3XRSnVcToN1rugCvuMH+IUgCVil4dLZCRePvu2xTRfB2Mu+PYuW4NrNyhOoDnq542QdhSo1PkHlfr3GL6kxF6rKhyrQ2AlXOmGUCVHZxXP10mWtZMflNFiiD/7WHRmR4Vipea0SuBig2wMXf99KYAQw4xLn4j2L/JD2wrWLlZZEOA961V1PdfXiJUQShjR2Y5mEQ/KhOgqXeKsLrM9JTbzxWfcbW5x5Q2CJRvDDbAsLx5pynqs8XHLrxyxc9FCGWz+GzRnGPYvG9fPm4BKwxOL4GoHqUB32VCLJR7a5dQDyOXgxZBl0Dq5CguXMvFVZ3XAJMyZNQXJbXyxlYxvBKgvXeofhoudiRQhc1jzXLlbe0TCBygMnc+suVF09vTHXozUus56KMzc7CJcK2IMj1NauVdMtJ621VzeOJtW3jR9OdYxW0w/m4JKb1hvKwSXzXqXhKlkoWNpzme5Z3EWoBK4drLRExlTxdRyqJ1j3Yxq1wDVCURYqe+EyBuyxPgF4zLNi8ppVCFipWTn4nqSv09FDmYBlGy6Z9zLAJcF86VWoBriKN2eYwGWE6rC3J07V4e6vO6Ea2VBSakciRVIssY7MpQgvC5e5Z/7IZGg02/BCfoFW+o2pQsASfTVgMC++PZYGle4SbcFl2JyhswKXyc4fVsBWVsphfSQSvD3qNFRdPb0wprEXgQhXqZaMSeEk5ZIjcKkuMCQCrxAqmaqoKFUYWKI+7Tvg7C3RpUaJxXCxmzTGXObhMlkoaAYu6Ra3CFT0igJVXQ3UZfQngfpcD1/V/aUQFkOi3RK4JOmu2YcbaF2lKVwSrC/39kd3H9ubUB1RhYKVfx0Yxw+9KyKy1PyWAkuOGlzmPZfsWbTkucIQGxKCQ/RUiXXYU6UeOqymFGJbB+IC68yQvtI0i7MBLsn2bM/TyjJpWQRLyqxoVXiJ6zZvxg7PpsUz8pbgEs8lYNnjuTazG4yPjMZRf1/UrAfVVZykm5JJy9OEJjeQUBV7JyNckntewCqBy+C5LMMFXaTyfkd27tDOUnGqeFSpT557HplBHbAkKNQGXIab1gou/m5tQ6zAlX9bNPbffz+cu3tVc9WLn/05AnAlNJLdl8RRhEZ5K1OzH640ggXWt0wtxLxk/zp2R1QpYIn6RnREflQEg3lbcJl4LoFLPFdomT2LrFjZ+bOOrvtYGCvLqxnily7TzlR7JUtfJLPLHE8/XGeAbd/DDQQuw8MNSsNl8FLira6zPr9q5IUXdVHamSpelQaWqH/Lljh7azSWl5k8dRYuuf0TSw8mt4AK/dtgd6f7kXn5ina22qWXIm/Fw4QqLSAC2fJYFkJ0mmA4+uQMU7gEqgv0/j97+aGzazPtTJWjSgXrPE3yPhzr2NH8SLEYLjmah8vcnkUZKa4L1CEpnBXn7orNb7+DC4ZT1nhN7P2q8lLzm7ell4omTOGGNJbqKN2gvXCV91x5fP3ONoGGxXuVrEo/w6lzuZjED5LQMcohuAyrUM3DpdbP8zWbxYMFhyJLp8N+j2ZY9VnNfGq+aN6IESo4/9TFA+eDo5BBL3WSwJimrlSZBgmI/XAZPJeMEHMY8B/yD1WToBcLCrWzVp4qH10q4XQqZvIDHYy2MMel498IjcBVfs+ijW1l/D2WcZzMc+XrQ7DR1RX/7TcIRdq5q7tkh7IA9Z6LK84GRSAnOFIlgLOUxdlg9sOVSrBy6N2PtNeraQV5/EtVqErAEh08fgqz+cHioy15LoHL4LnWOQGXJCGJZUXv5N8LwvRYzXNNe+ppbIrdpl1B9VHi9p34qFt31eWNdGmOdHphAeoUgRKPpFJWCkAW4FIpwvk6W3DJPJd0f4f8gxVUsrWuqlRlYInEc8lGjKRbOloI6AmXAou/OwHXdsK1na/bzAqXG9fpYXT/3t4Y1cwdn7/SG4cPJmhXUvU6FZ+ACa+/pp7j2IM2z7MNCnXRSOdoTxLqSi7UZA0qo1mDS8zao/BSO+hRyFBih2+wAjg/I0u7kqpRlYIlOpmdg6/4QdNuibYwFWEdLsNNa0tw6QmX3nBvkbaNFb6NlR3P9+bSiy1s2gRv89wDuvfA/NHjkJdXeWviC/PysGRcDIb16KEevC6ZWia7tsBxaXAO808Hl2QUlOMJSVkZVDqLs7Nwyf3Cq/SAi738cQfPWxUxVVlVOVgiuX/+kY8P8qMj8LMFuAxdojW4GMjbgEtMUlbuZMNtZ4XvlliDr8/Q67DCq5V6ulk3Wq+IWzC6z1uYx+B/7+q1yDpj//x+dtoZ7F21BguGj0BMnzfxcsStqjEfokm+hIXNfZHG8+fqIg0w8TokL5cx8ZsRLslL7wxchhGjwGToFgUs2QjxZSMvdHF1066y6nVTwDLq/ahbURASgBUEwXQFanm4TLaV2QGXWj9fDFfJQkHZnLGLDRdH20OT/Yen9ZHqAU6rfPwwpYkXBhMImeWWh6ULILJTpZP2uzznWp7OLx5I1pbL3yUR/2u04S7umOXmg1jfDkgPZRDOctN4Lcd5TZKX6ygBlzRKxXm6zMClHstiBi57HssicMmM+/WQSDWj/iJBvpm6qWCJRvV8AYe93LE1LKJcUG+Ey6E9i6ZwBWvr58vAVWr9PP8nto9/P8jXHOFrkkPpXdgwGWFRSNGz0VlmAl97hA1+gtCk6aOQRcukSe7SVF0E4QxHEl8nqSklCUkCy0xU5Rl+L5dRsALhkmmJrEBeF01yWFXWbRpHdNPBEq3btAmLWCGnOkaV6xpLw1WyIkLBxb87D5f5PYuylWwvvYuYPJXfNMONMnanahs/yztAO0STFJXGfBHqyPeZpk8ywnXUDFzmsjgb4AqzCZfBU4XjSkgUFnu3U3NUR3Zu12r15qpagCXKuHoNXwYEoiA0AKsIhuky5xK4eDSFi43gCFyObiszJiOxlj7pAM00CYktuMp7LvMpwm3BJV7qLH+WydSXCFSPCl5PdaOqNmAZNeWdd7GzkQsSoyKxhJWqZuatwCWz80a4BCoFF383biszBPQl28qcgcvSVn5bcCUw7rEHrqMcxVmFS01FmIBFu0Qvtc4n0HCTemjFrfysKFU7sERJGdmY7B+A/KD2WEegJLi3BddG/n2Tqefi77LcRuCSe4s3ApcCzAxc1tInGeGy23Mx3rIIFwE1zHOFIzsoAllBkfg3gXrcs2WFrVGvaFVLsIyaP34CfmEFZkSFYxnhKp2EpPyeRYGrVLcoUBEiQ5dYsvNHxVxqGsIIl2Hnj224BCpTuHQq1rIKF99nzCpoBEtMcqOWhcvSkzMErjPipThQGO/aUnmpldOna7VUPVWtwRLJqoUZTz6D+MYNkRQepvYvrhKoOAoTuBzfs+jYhlibnovdtV1wifHnUnDxb9Y8lxxl7uuSPhoLPP3UqoTh3Sr28TGVpWoPllEn84vwY9eHkOzWBIkEbBkbVxLtSrdobVuZEa7SmzMs7Vm0F64ynssGXOpnvs8cXDIlYc5zpfJzXNR3xE/N/dQUQv9OnW8ol0JVq8aAZVRCWjqWPPIYjjZuhORwPVaxcZYHGZ6aYQkuFdSXg0u2lZX2XKYbYq3BJV7rV763IuBSXST/JhOox3lMpyfOCY3EdLdW+C2BGtTlQadTCd1M1TiwjDp98TJW9PoPdjZsgGxdMAHSYQUbVu4zigczxFyO7Vk0B1ecKVz8vyW41EjRDFxGsMzBlcjXHuXxBK8rXx+Ffe1CMMTFVWU5Htmzp1OZ9KqLaixYRl2i/TJ6HNaEhCKjpReS9YSJjSxJ4daz8TfIcppQk4WCpeCS6YjScEm8ZRUumrNwqYlU/k+6vxM8R7bcTuJ7prr5qDzqDzd0x+KYGMMHq+Gq8WCZ6sDxE9j4Rh+sb9kC59r44LgulCNABvts7LU8ytP4N9MELpnnMgsXuySbcPG11uAydosClRzFU8ltoRSeLyc8GnHtgjHRtYVa8fBH2rhXXkZWStU8lL2qVKvAMtXu/YcQO2AgNnXsiMMcUZ4L7oAjISHYRc+2gY2/ng2+MVBnCOwFNA0umYowhUugMlqpmEvg0qwYLgGKr0ugyc3nNF0EssOisdM/GLPcfdDPpYG6qd3DvRUm9+2LlMQj2tXWPtVasEwlz6Bf991cbOvTFxtvvRWb2biZfq2RGRzI+CYY8ewuxTPt4FFyQ8hW/q0cmclSm60B9GQB9HyBNB7jCOMe/l9m5PfTDvH/R4IiVNx0kh5pZ9sAzGjmg/cZK/2d55Flx3/38sOY117F+plzDBdUB1QnwDKnOHq0NTGTsaH/QKx59HGsiorCksauWEcQ4tya4XALbxxv3Qopbf1wpn07pHVoh1Pt/ZHg54u4lj5Y08wD3zdogi/5+rdoMhPe07MN+tzXCZP6v4NlYycg9UiSdra6pzoLljWlFRRif3wiYjdswYqflmDR3AX437TZ+GnaHCz9YQHWLFqKuNhtSDpyFPnnL2rvqpep6sGqV6WoHqx6VYrqwapXpagerHpViurBqlelqB6selWCgP8H0vxXZO18UWEAAAAASUVORK5CYII="
-- please keep this here
local PingStat = game:service("Stats").PerformanceStats.Ping
local function GetLatency()
	return PingStat:GetValue() / 1000
end
placeholderImage = syn.crypt.base64.decode(placeholderImage)
if not isfile("bitchbot/chatspam.txt") then --idk help the user out lol, prevent stupid errors --well it would kinda ig
	writefile(
		"bitchbot/chatspam.txt",
		[[
WSUP FOOL
GET OWNED KID
BBOAT ON TOP
I LOVE BBOT YEAH
PLACEHOLDER TEXT 
dear bbot user, edit your chat spam
	]]
	)
end

if not isfile("bitchbot/killsay.txt") then
	writefile(
		"bitchbot/killsay.txt",
		[[
WSUP FOOL [name]
GET OWNED [name]
[name] just died to my [weapon] everybody laugh
[name] got owned roflsauce
PLACEHOLDER TEXT 
dear bbot user, edit your kill say
	]]
	)
end

do
	local customtxt = readfile("bitchbot/chatspam.txt")
	for s in customtxt:gmatch("[^\n]+") do -- I'm Love String:Match
		table.insert(customChatSpam, s) -- I'm care
	end
	customtxt = readfile("bitchbot/killsay.txt")
	for s in customtxt:gmatch("[^\n]+") do -- I'm Love String:Match
		table.insert(customKillSay, s)
	end
end

local function map(N, OldMin, OldMax, Min, Max)
	return (N - OldMin) / (OldMax - OldMin) * (Max - Min) + Min
end
local CreateNotification
do
	local notes = {}
	local function DrawingObject(t, col)
		local d = Drawing.new(t)

		d.Visible = true
		d.Transparency = 1
		d.Color = col

		return d
	end

	local function Rectangle(sizex, sizey, fill, col)
		local s = DrawingObject("Square", col)

		s.Filled = fill
		s.Thickness = 1
		s.Position = Vector2.new()
		s.Size = Vector2.new(sizex, sizey)

		return s
	end

	local function Text(text)
		local s = DrawingObject("Text", Color3.new(1, 1, 1))

		s.Text = text
		s.Size = 13
		s.Center = false
		s.Outline = true
		s.Position = Vector2.new()
		s.Font = 2

		return s
	end

	CreateNotification = function(t, customcolor) -- TODO i want some kind of prioritized message to the notification list, like a warning or something. warnings have icons too maybe? idk??
		local gap = 25
		local width = 18

		local alpha = 255
		local time = 0
		local estep = 0
		local eestep = 0.02

		local insety = 0

		local Note = {

			enabled = true,

			targetPos = Vector2.new(50, 33),

			size = Vector2.new(200, width),

			drawings = {
				outline = Rectangle(202, width + 2, false, Color3.new(0, 0, 0)),
				fade = Rectangle(202, width + 2, false, Color3.new(0, 0, 0)),
			},

			Remove = function(self, d)
				if d.Position.x < d.Size.x then
					for k, drawing in pairs(self.drawings) do
						drawing:Remove()
						drawing = false
					end
					self.enabled = false
				end
			end,

			Update = function(self, num, listLength, dt)
				local pos = self.targetPos

				local indexOffset = (listLength - num) * gap
				if insety < indexOffset then
					insety -= (insety - indexOffset) * 0.2
				else
					insety = indexOffset
				end
				local size = self.size

				local tpos = Vector2.new(pos.x - size.x / time - map(alpha, 0, 255, size.x, 0), pos.y + insety)
				self.pos = tpos

				local locRect = {
					x = math.ceil(tpos.x),
					y = math.ceil(tpos.y),
					w = math.floor(size.x - map(255 - alpha, 0, 255, 0, 70)),
					h = size.y,
				}
				--pos.set(-size.x / fc - map(alpha, 0, 255, size.x, 0), pos.y)

				local fade = math.min(time * 12, alpha)
				fade = fade > 255 and 255 or fade < 0 and 0 or fade

				if self.enabled then
					local linenum = 1
					for i, drawing in pairs(self.drawings) do
						drawing.Transparency = fade / 255

						if type(i) == "number" then
							drawing.Position = Vector2.new(locRect.x + 1, locRect.y + i)
							drawing.Size = Vector2.new(locRect.w - 2, 1)
						elseif i == "text" then
							drawing.Position = tpos + Vector2.new(6, 2)
						elseif i == "outline" then
							drawing.Position = Vector2.new(locRect.x, locRect.y)
							drawing.Size = Vector2.new(locRect.w, locRect.h)
						elseif i == "fade" then
							drawing.Position = Vector2.new(locRect.x - 1, locRect.y - 1)
							drawing.Size = Vector2.new(locRect.w + 2, locRect.h + 2)
							local t = (200 - fade) / 255 / 3
							drawing.Transparency = t < 0.4 and 0.4 or t
						elseif i:find("line") then
							drawing.Position = Vector2.new(locRect.x + linenum, locRect.y + 1)
							if menu then
								local mencol = customcolor or (
										menu:GetVal("Settings", "Cheat Settings", "Menu Accent") and Color3.fromRGB(unpack(menu:GetVal("Settings", "Cheat Settings", "Menu Accent", COLOR))) or Color3.fromRGB(127, 72, 163)
									)
								local color = linenum == 1 and mencol or Color3.fromRGB(mencol.R * 255 - 40, mencol.G * 255 - 40, mencol.B * 255 - 40) -- super shit
								if drawing.Color ~= color then
									drawing.Color = color
								end
							end
							linenum += 1
						end
					end

					time += estep * dt * 128 -- TODO need to do the duration
					estep += eestep * dt * 64
				end
			end,

			Fade = function(self, num, len, dt)
				if self.pos.x > self.targetPos.x - 0.2 * len or self.fading then
					if not self.fading then
						estep = 0
					end
					self.fading = true
					alpha -= estep / 4 * len * dt * 50
					eestep += 0.01 * dt * 100
				end
				if alpha <= 0 then
					self:Remove(self.drawings[1])
				end
			end,
		}

		for i = 1, Note.size.y - 2 do
			local c = 0.28 - i / 80
			Note.drawings[i] = Rectangle(200, 1, true, Color3.new(c, c, c))
		end
		local color = (menu and menu.GetVal) and customcolor or menu:GetVal("Settings", "Cheat Settings", "Menu Accent") and Color3.fromRGB(unpack(menu:GetVal("Settings", "Cheat Settings", "Menu Accent", COLOR))) or Color3.fromRGB(127, 72, 163)

		Note.drawings.text = Text(t)
		if Note.drawings.text.TextBounds.x + 7 > Note.size.x then -- expand the note size to fit if it's less than the default size
			Note.size = Vector2.new(Note.drawings.text.TextBounds.x + 7, Note.size.y)
		end
		Note.drawings.line = Rectangle(1, Note.size.y - 2, true, color)
		Note.drawings.line1 = Rectangle(1, Note.size.y - 2, true, color)

		notes[#notes + 1] = Note
	end

	renderStepped = game.RunService.RenderStepped:Connect(function(dt)
		Camera = workspace.CurrentCamera
		local smallest = math.huge
		for k = 1, #notes do
			local v = notes[k]
			if v and v.enabled then
				smallest = k < smallest and k or smallest
			else
				table.remove(notes, k)
			end
		end
		local length = #notes
		for k = 1, #notes do
			local note = notes[k]
			note:Update(k, length, dt)
			if k <= math.ceil(length / 10) or note.fading then
				note:Fade(k, length, dt)
			end
		end
	end)
	--ANCHOR how to create notification
	--CreateNotification("Loading...")
end

--validity check
--SECTION commented these out for development

-- make_synreadonly(syn)
-- make_synreadonly(Drawing)
-- protectfunction(getgenv)
-- protectfunction(getgc)

-- local init
-- if syn then
-- 	init = getfenv(saveinstance).script
-- end

-- script.Name = "\1"
-- local function search_hookfunc(tbl)
-- 	for i,v in pairs(tbl) do
-- 		local s = getfenv(v).script
-- 		if is_synapse_function(v) and islclosure(v) and s and s ~= script and s.Name ~= "\1" and s ~= init then
-- 			if tostring(unpack(debug.getconstants(v))):match("hookfunc") or tostring(unpack(debug.getconstants(v))):match("hookfunction") then
-- 				writefile("poop.text", "did the funny")
-- 				SX_CRASH()
-- 				break
-- 			end
-- 		end
-- 	end
-- end
-- search_hookfunc(getgc())
-- search_hookfunc = nil

-- if syn.crypt.derive(BBOT.username, 32) ~= BBOT.check then SX_CRASH() end

--!SECTION
local menuWidth, menuHeight = 500, 600
menu = { -- this is for menu stuffs n shi
	w = menuWidth,
	h = menuHeight,
	x = 0,
	y = 0,
	columns = {
		width = math.floor((menuWidth - 40) / 2),
		left = 17,
		right = math.floor((menuWidth - 20) / 2) + 13,
	},
	activetab = 1,
	open = true,
	fadestart = 0,
	fading = false,
	mousedown = false,
	postable = {},
	options = {},
	clrs = {
		norm = {},
		dark = {},
		togz = {},
	},
	mc = { 127, 72, 163 },
	watermark = {},
	connections = {},
	list = {},
	unloaded = false,
	copied_clr = nil,
	game = "uni",
	tabnames = {}, -- its used to change the tab num to the string (did it like this so its dynamic if u add or remove tabs or whatever :D)
	friends = {},
	priority = {},
	muted = {},
	spectating = false,
	stat_menu = false,
	load_time = 0,
	log_multi = nil,
	mgrouptabz = {},
	backspaceheld = false,
	backspacetime = -1,
	backspaceflags = 0,
	selectall = false,
	modkeys = {
		alt = {
			direction = nil,
		},
		shift = {
			direction = nil,
		},
	},
	modkeydown = function(self, key, direction)
		local keydata = self.modkeys[key]
		return keydata.direction and keydata.direction == direction or false
	end,
	keybinds = {},
	values = {}
}

local function round(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function average(t)
	local sum = 0
	for _, v in pairs(t) do -- Get the sum of all numbers in t
		sum = sum + v
	end
	return sum / #t
end

local function clamp(a, lowerNum, higher) -- DONT REMOVE this clamp is better then roblox's because it doesnt error when its not lower or heigher
	if a > higher then
		return higher
	elseif a < lowerNum then
		return lowerNum
	else
		return a
	end
end

local function CreateThread(func, ...) -- improved... yay.
	local thread = coroutine.create(func)
	coroutine.resume(thread, ...)
	return thread
end

local function MultiThreadList(obj, ...)
	local n = #obj
	if n > 0 then
		for i = 1, n do
			local t = obj[i]
			if type(t) == "table" then
				local d = #t
				assert(d ~= 0, "table inserted was not an array or was empty")
				assert(d < 3, ("invalid number of arguments (%d)"):format(d))
				local thetype = type(t[1])
				assert(
					thetype == "function",
					("invalid argument #1: expected 'function', got '%s'"):format(tostring(thetype))
				)

				CreateThread(t[1], unpack(t[2]))
			else
				CreateThread(t, ...)
			end
		end
	else
		for i, v in pairs(obj) do
			CreateThread(v, ...)
		end
	end
end

local DeepRestoreTableFunctions, DeepCleanupTable

DeepRestoreTableFunctions = function(tbl)
	for k, v in next, tbl do
		if type(v) == "function" and is_synapse_function(v) then
			for k1, v1 in next, getupvalues(v) do
				if type(v1) == "function" and islclosure(v1) and not is_synapse_function(v1) then
					tbl[k] = v1
				end
			end
		end

		if type(v) == "table" then
			DeepRestoreTableFunctions(v)
		end
	end
end

DeepCleanupTable = function(tbl)
	local numTable = #tbl
	local isTableArray = numTable > 0
	if isTableArray then
		for i = 1, numTable do
			local entry = tbl[i]
			local entryType = type(entry)

			if entryType == "table" then
				DeepCleanupTable(tbl)
			end

			tbl[i] = nil
			entry = nil
			entryType = nil
		end
	else
		for k, v in next, tbl do
			if type(v) == "table" then
				DeepCleanupTable(tbl)
			end
		end

		tbl[k] = nil
	end

	numTable = nil
	isTableArray = nil
end

local event = {}

local allevent = {}

function event.new(eventname, eventtable, requirename) -- fyi you can put in a table of choice to make the table you want an "event" pretty cool its like doing & in c lol!
	if eventname then
		assert(
			allevent[eventname] == nil,
			("the event '%s' already exists in the event table"):format(eventname)
		)
	end
	local newevent = eventtable or {}
	local funcs = {}
	local disconnectlist = {}
	function newevent:fire(...)
		allevent[eventname].fire(...)
	end
	function newevent:connect(func)
		funcs[#funcs + 1] = func
		local disconnected = false
		local function disconnect()
			if not disconnected then
				disconnected = true
				disconnectlist[func] = true
			end
		end
		return disconnect
	end

	local function fire(...)
		local n = #funcs
		local j = 0
		for i = 1, n do
			local func = funcs[i]
			if disconnectlist[func] then
				disconnectlist[func] = nil
			else
				j = j + 1
				funcs[j] = func
			end
		end
		for i = j + 1, n do
			funcs[i] = nil
		end
		for i = 1, j do
			CreateThread(function(...)
				pcall(funcs[i], ...)
			end, ...)
		end
	end

	if eventname then
		allevent[eventname] = {
			event = newevent,
			fire = fire,
		}
	end

	return newevent, fire
end

local function FireEvent(eventname, ...)
	if allevent[eventname] then
		return allevent[eventname].fire(...)
	else
		--warn(("Event %s does not exist!"):format(eventname))
	end
end

local function GetEvent(eventname)
	return allevent[eventname]
end

local BBOT_IMAGES = {}
MultiThreadList({
	function()
		BBOT_IMAGES[1] = game:HttpGet("https://i.imgur.com/9NMuFcQ.png")
	end,
	function()
		BBOT_IMAGES[2] = game:HttpGet("https://i.imgur.com/jG3NjxN.png")
	end,
	function()
		BBOT_IMAGES[3] = game:HttpGet("https://i.imgur.com/2Ty4u2O.png")
	end,
	function()
		BBOT_IMAGES[4] = game:HttpGet("https://i.imgur.com/kNGuTlj.png")
	end,
	function()
		BBOT_IMAGES[5] = game:HttpGet("https://i.imgur.com/OZUR3EY.png")
	end,
	function()
		BBOT_IMAGES[6] = game:HttpGet("https://i.imgur.com/3HGuyVa.png")
	end,
})

-- MULTITHREAD DAT LOADING SO FAST!!!!
local loaded = {}
do
	local function Loopy_Image_Checky()
		for i = 1, 6 do
			local v = BBOT_IMAGES[i]
			if v == nil then
				return true
			elseif not loaded[i] then
				loaded[i] = true
			end
		end
		return false
	end
	while Loopy_Image_Checky() do
		wait(0)
	end
end

if game.PlaceId == 292439477 or game.PlaceId == 299659045 or game.PlaceId == 5281922586 or game.PlaceId == 3568020459
then -- they sometimes open 5281922586
	menu.game = "pf"
	do
		local net

		repeat
			local gc = getgc(true)

			for i = 1, #gc do
				local garbage = gc[i]

				local garbagetype = type(garbage)

				if garbagetype == "table" then
					net = rawget(garbage, "fetch")
					if net then
						break
					end
				end
			end

			gc = nil
			game.RunService.RenderStepped:Wait()
		until net

		net = nil

		local annoyingFuckingMusic = workspace:FindFirstChild("memes")
		if annoyingFuckingMusic then
			annoyingFuckingMusic:Destroy()
		end
	end -- wait for framwork to load
elseif game.PlaceId == 5898483760 or game.PlaceId == 5565011975 then
	--menu.game = "dust"
end

loadstart = tick()

-- nate i miss u D:
-- im back
local NETWORK = game:service("NetworkClient")
local NETWORK_SETTINGS = settings().Network
NETWORK:SetOutgoingKBPSLimit(0)

setfpscap(getgenv().maxfps or 144)

if not isfolder("bitchbot") then
	makefolder("bitchbot")
	if not isfile("bitchbot/relations.bb") then
		writefile("bitchbot/relations.bb", "bb:{{friends:}{priority:}")
	end
else
	if not isfile("bitchbot/relations.bb") then
		writefile("bitchbot/relations.bb", "bb:{{friends:}{priority:}")
	end
	writefile("bitchbot/debuglog.bb", "")
end

if not isfolder("bitchbot/" .. menu.game) then
	makefolder("bitchbot/" .. menu.game)
end

local configs = {}

local function GetConfigs()
	local result = {}
	local directory = "bitchbot\\" .. menu.game
	for k, v in pairs(listfiles(directory)) do
		local clipped = v:sub(#directory + 2)
		if clipped:sub(#clipped - 2) == ".bb" then
			clipped = clipped:sub(0, #clipped - 3)
			result[k] = clipped
			configs[k] = v
		end
	end
	if #result <= 0 then
		writefile("bitchbot/" .. menu.game .. "/Default.bb", "")
	end
	return result
end

local Players = game:GetService("Players")
local LIGHTING = game:GetService("Lighting")
local stats = game:GetService("Stats")

local function UnpackRelations()
	local str = isfile("bitchbot/relations.bb") and readfile("bitchbot/relations.bb") or nil
	local final = {
		friends = {},
		priority = {},
	}
	if str then
		if str:find("bb:{{") then
			writefile("bitchbot/relations.bb", "friends:\npriority:")
			return
		end

		local friends, frend = str:find("friends:")
		local priority, priend = str:find("\npriority:")
		local friendslist = str:sub(frend + 1, priority - 1)
		local prioritylist = str:sub(priend + 1)
		for i in friendslist:gmatch("[^,]+") do
			if not table.find(final.friends, i) then
				table.insert(final.friends, i)
			end
		end
		for i in prioritylist:gmatch("[^,]+") do
			if not table.find(final.priority, i) then
				table.insert(final.priority, i)
			end
		end
	end
	if not menu then
		repeat
			game.RunService.Heartbeat:Wait()
		until menu
	end
	menu.friends = final.friends
	if not table.find(menu.friends, Players.LocalPlayer.Name) then
		table.insert(menu.friends, Players.LocalPlayer.Name)
	end
	menu.priority = final.priority
end

local function WriteRelations()
	local str = "friends:"

	for k, v in next, menu.friends do
		local playerobj
		local userid
		local pass, ret = pcall(function()
			playerobj = Players[v]
		end)

		if not pass then
			local newpass, newret = pcall(function()
				userid = v
			end)
		end

		if userid then
			str ..= tostring(userid) .. ","
		else
			str ..= tostring(playerobj.Name) .. ","
		end
	end

	str ..= "\npriority:"

	for k, v in next, menu.priority do
		local playerobj
		local userid
		local pass, ret = pcall(function()
			playerobj = Players[v]
		end)

		if not pass then
			local newpass, newret = pcall(function()
				userid = v
			end)
		end

		if userid then
			str ..= tostring(userid) .. ","
		else
			str ..= tostring(playerobj.Name) .. ","
		end
	end

	writefile("bitchbot/relations.bb", str)
end
CreateThread(function()
	if (not menu or not menu.GetVal) then
		repeat
			game.RunService.Heartbeat:Wait()
		until (menu and menu.GetVal)
	end
	wait(2)
	UnpackRelations()
	WriteRelations()
end)

local LOCAL_PLAYER = Players.LocalPlayer
local LOCAL_MOUSE = LOCAL_PLAYER:GetMouse()
local TEAMS = game:GetService("Teams")
local INPUT_SERVICE = game:GetService("UserInputService")
local TELEPORT_SERVICE = game:GetService("TeleportService")
--local GAME_SETTINGS = UserSettings():GetService("UserGameSettings")
local CACHED_VEC3 = Vector3.new()
local Camera = workspace.CurrentCamera
local SCREEN_SIZE = Camera.ViewportSize
--[[ local ButtonPressed = Instance.new("BindableEvent")
local TogglePressed = Instance.new("BindableEvent") ]]

local ButtonPressed = event.new("bb_buttonpressed")
local TogglePressed = event.new("bb_togglepressed")
local MouseMoved = event.new("bb_mousemoved")

--local PATHFINDING = game:GetService("PathfindingService")
local GRAVITY = Vector3.new(0, -192.6, 0)

menu.x = math.floor((SCREEN_SIZE.x / 2) - (menu.w / 2))
menu.y = math.floor((SCREEN_SIZE.y / 2) - (menu.h / 2))

local Lerp = function(delta, from, to) -- wtf why were these globals thats so exploitable!
	if (delta > 1) then
		return to
	end
	if (delta < 0) then
		return from
	end
	return from + (to - from) * delta
end

local ColorRange = function(value, ranges) -- ty tony for dis function u a homie
	if value <= ranges[1].start then
		return ranges[1].color
	end
	if value >= ranges[#ranges].start then
		return ranges[#ranges].color
	end

	local selected = #ranges
	for i = 1, #ranges - 1 do
		if value < ranges[i + 1].start then
			selected = i
			break
		end
	end
	local minColor = ranges[selected]
	local maxColor = ranges[selected + 1]
	local lerpValue = (value - minColor.start) / (maxColor.start - minColor.start)
	return Color3.new(
		Lerp(lerpValue, minColor.color.r, maxColor.color.r),
		Lerp(lerpValue, minColor.color.g, maxColor.color.g),
		Lerp(lerpValue, minColor.color.b, maxColor.color.b)
	)
end

local bVector2 = {}
do -- vector functions
	function bVector2:getRotate(Vec, Rads)
		local vec = Vec.Unit
		--x2 = cos β x1 − sin β y1
		--y2 = sin β x1 + cos β y1
		local sin = math.sin(Rads)
		local cos = math.cos(Rads)
		local x = (cos * vec.x) - (sin * vec.y)
		local y = (sin * vec.x) + (cos * vec.y)

		return Vector2.new(x, y).Unit * Vec.Magnitude
	end
end
local bColor = {}
do -- color functions
	function bColor:Mult(col, mult)
		return Color3.new(col.R * mult, col.G * mult, col.B * mult)
	end
	function bColor:Add(col, num)
		return Color3.new(col.R + num, col.G + num, col.B + num)
	end
end
local function string_cut(s1, num)
	return num == 0 and s1 or string.sub(s1, 1, num)
end

local textBoxLetters = {
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
}

local keyNames = {
	One = "1",
	Two = "2",
	Three = "3",
	Four = "4",
	Five = "5",
	Six = "6",
	Seven = "7",
	Eight = "8",
	Nine = "9",
	Zero = "0",
	LeftBracket = "[",
	RightBracket = "]",
	Semicolon = ";",
	BackSlash = "\\",
	Slash = "/",
	Minus = "-",
	Equals = "=",
	Return = "Enter",
	Backquote = "`",
	CapsLock = "Caps",
	LeftShift = "LShift",
	RightShift = "RShift",
	LeftControl = "LCtrl",
	RightControl = "RCtrl",
	LeftAlt = "LAlt",
	RightAlt = "RAlt",
	Backspace = "Back",
	Plus = "+",
	Multiply = "x",
	PageUp = "PgUp",
	PageDown = "PgDown",
	Delete = "Del",
	Insert = "Ins",
	NumLock = "NumL",
	Comma = ",",
	Period = ".",
}
local colemak = {
	E = "F",
	R = "P",
	T = "G",
	Y = "J",
	U = "L",
	I = "U",
	O = "Y",
	P = ";",
	S = "R",
	D = "S",
	F = "T",
	G = "D",
	J = "N",
	K = "E",
	L = "I",
	[";"] = "O",
	N = "K",
}

local keymodifiernames = {
	["`"] = "~",
	["1"] = "!",
	["2"] = "@",
	["3"] = "#",
	["4"] = "$",
	["5"] = "%",
	["6"] = "^",
	["7"] = "&",
	["8"] = "*",
	["9"] = "(",
	["0"] = ")",
	["-"] = "_",
	["="] = "+",
	["["] = "{",
	["]"] = "}",
	["\\"] = "|",
	[";"] = ":",
	["'"] = '"',
	[","] = "<",
	["."] = ".",
	["/"] = "?",
}

local function KeyEnumToName(key) -- did this all in a function cuz why not
	if key == nil then
		return "None"
	end
	local _key = tostring(key) .. "."
	local _key = _key:gsub("%.", ",")
	local keyname = nil
	local looptime = 0
	for w in _key:gmatch("(.-),") do
		looptime = looptime + 1
		if looptime == 3 then
			keyname = w
		end
	end
	if string.match(keyname, "Keypad") then
		keyname = string.gsub(keyname, "Keypad", "")
	end

	if keyname == "Unknown" or key.Value == 27 then
		return "None"
	end

	if keyNames[keyname] then
		keyname = keyNames[keyname]
	end
	if Nate then
		return colemak[keyname] or keyname
	else
		return keyname
	end
end

local invalidfilekeys = {
	["\\"] = true,
	["/"] = true,
	[":"] = true,
	["*"] = true,
	["?"] = true,
	['"'] = true,
	["<"] = true,
	[">"] = true,
	["|"] = true,
}

local function KeyModifierToName(key, filename)
	if keymodifiernames[key] ~= nil then
		if filename then
			if invalidfilekeys[keymodifiernames[key]] then
				return ""
			else
				return keymodifiernames[key]
			end
		else
			return keymodifiernames[key]
		end
	else
		return ""
	end
end

local allrender = {}

local RGB = Color3.fromRGB
local Draw = {}
do
	function Draw:UnRender()
		for k, v in pairs(allrender) do
			for k1, v1 in pairs(v) do
				--warn(k1, v1)
				-- ANCHOR WHAT THE FUCK IS GOING ON WITH THIS WHY IS THIS ERRORING BECAUSE OF NUMBER
				if v1 and type(v1) ~= "number" and v1.__OBJECT_EXISTS then
					v1:Remove()
				else
					--rconsolewarn(tostring(k),tostring(v),tostring(k1),tostring(v1)) -- idfk why but this shit doesn't print anything out. might as well have it commented out though -nata april 1 21
				end
			end
		end
	end

	function Draw:OutlinedRect(visible, pos_x, pos_y, width, height, clr, tablename)
		local temptable = Drawing.new("Square")
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = Vector2.new(width, height)
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Filled = false
		temptable.Thickness = 0
		temptable.Transparency = clr[4] / 255
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function Draw:FilledRect(visible, pos_x, pos_y, width, height, clr, tablename)
		local temptable = Drawing.new("Square")
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = Vector2.new(width, height)
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Filled = true
		temptable.Thickness = 0
		temptable.Transparency = clr[4] / 255
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function Draw:Line(visible, thickness, start_x, start_y, end_x, end_y, clr, tablename)
		temptable = Drawing.new("Line")
		temptable.Visible = visible
		temptable.Thickness = thickness
		temptable.From = Vector2.new(start_x, start_y)
		temptable.To = Vector2.new(end_x, end_y)
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Transparency = clr[4] / 255
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function Draw:Image(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
		local temptable = Drawing.new("Image")
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = Vector2.new(width, height)
		temptable.Transparency = transparency
		temptable.Data = imagedata or placeholderImage
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function Draw:Text(text, font, visible, pos_x, pos_y, size, centered, clr, tablename)
		local temptable = Drawing.new("Text")
		temptable.Text = text
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = size
		temptable.Center = centered
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Transparency = clr[4] / 255
		temptable.Outline = false
		temptable.Font = font
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function Draw:OutlinedText(text, font, visible, pos_x, pos_y, size, centered, clr, clr2, tablename)
		local temptable = Drawing.new("Text")
		temptable.Text = text
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = size
		temptable.Center = centered
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Transparency = clr[4] / 255
		temptable.Outline = true
		temptable.OutlineColor = RGB(clr2[1], clr2[2], clr2[3])
		temptable.Font = font
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
		if tablename then
			table.insert(tablename, temptable)
		end
		return temptable
	end

	function Draw:Triangle(visible, filled, pa, pb, pc, clr, tablename)
		clr = clr or { 255, 255, 255, 1 }
		local temptable = Drawing.new("Triangle")
		temptable.Visible = visible
		temptable.Transparency = clr[4] or 1
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Thickness = 4.1
		if pa and pb and pc then
			temptable.PointA = Vector2.new(pa[1], pa[2])
			temptable.PointB = Vector2.new(pb[1], pb[2])
			temptable.PointC = Vector2.new(pc[1], pc[2])
		end
		temptable.Filled = filled
		table.insert(tablename, temptable)
		if tablename and not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function Draw:Circle(visible, pos_x, pos_y, size, thickness, sides, clr, tablename)
		local temptable = Drawing.new("Circle")
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Visible = visible
		temptable.Radius = size
		temptable.Thickness = thickness
		temptable.NumSides = sides
		temptable.Transparency = clr[4]
		temptable.Filled = false
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function Draw:FilledCircle(visible, pos_x, pos_y, size, thickness, sides, clr, tablename)
		local temptable = Drawing.new("Circle")
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Visible = visible
		temptable.Radius = size
		temptable.Thickness = thickness
		temptable.NumSides = sides
		temptable.Transparency = clr[4]
		temptable.Filled = true
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	--ANCHOR MENU ELEMENTS

	function Draw:MenuOutlinedRect(visible, pos_x, pos_y, width, height, clr, tablename)
		Draw:OutlinedRect(visible, pos_x + menu.x, pos_y + menu.y, width, height, clr, tablename)
		table.insert(menu.postable, { tablename[#tablename], pos_x, pos_y })

		if menu.log_multi ~= nil then
			table.insert(menu.mgrouptabz[menu.log_multi[1]][menu.log_multi[2]], tablename[#tablename])
		end
	end

	function Draw:MenuFilledRect(visible, pos_x, pos_y, width, height, clr, tablename)
		Draw:FilledRect(visible, pos_x + menu.x, pos_y + menu.y, width, height, clr, tablename)
		table.insert(menu.postable, { tablename[#tablename], pos_x, pos_y })

		if menu.log_multi ~= nil then
			table.insert(menu.mgrouptabz[menu.log_multi[1]][menu.log_multi[2]], tablename[#tablename])
		end
	end

	function Draw:MenuImage(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
		Draw:Image(visible, imagedata, pos_x + menu.x, pos_y + menu.y, width, height, transparency, tablename)
		table.insert(menu.postable, { tablename[#tablename], pos_x, pos_y })

		if menu.log_multi ~= nil then
			table.insert(menu.mgrouptabz[menu.log_multi[1]][menu.log_multi[2]], tablename[#tablename])
		end
	end

	function Draw:MenuBigText(text, visible, centered, pos_x, pos_y, tablename)
		local text = Draw:OutlinedText(
			text,
			2,
			visible,
			pos_x + menu.x,
			pos_y + menu.y,
			13,
			centered,
			{ 255, 255, 255, 255 },
			{ 0, 0, 0 },
			tablename
		)
		table.insert(menu.postable, { tablename[#tablename], pos_x, pos_y })

		if menu.log_multi ~= nil then
			table.insert(menu.mgrouptabz[menu.log_multi[1]][menu.log_multi[2]], tablename[#tablename])
		end

		return text
	end

	function Draw:CoolBox(name, x, y, width, height, tab)
		Draw:MenuOutlinedRect(true, x, y, width, height, { 0, 0, 0, 255 }, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 1, width - 2, height - 2, { 20, 20, 20, 255 }, tab)
		Draw:MenuOutlinedRect(true, x + 2, y + 2, width - 3, 1, { 127, 72, 163, 255 }, tab)
		table.insert(menu.clrs.norm, tab[#tab])
		Draw:MenuOutlinedRect(true, x + 2, y + 3, width - 3, 1, { 87, 32, 123, 255 }, tab)
		table.insert(menu.clrs.dark, tab[#tab])
		Draw:MenuOutlinedRect(true, x + 2, y + 4, width - 3, 1, { 20, 20, 20, 255 }, tab)

		for i = 0, 7 do
			Draw:MenuFilledRect(true, x + 2, y + 5 + (i * 2), width - 4, 2, { 45, 45, 45, 255 }, tab)
			tab[#tab].Color = ColorRange(
				i,
				{ [1] = { start = 0, color = RGB(45, 45, 45) }, [2] = { start = 7, color = RGB(35, 35, 35) } }
			)
		end

		Draw:MenuBigText(name, true, false, x + 6, y + 5, tab)
	end

	function Draw:CoolMultiBox(names, x, y, width, height, tab)
		Draw:MenuOutlinedRect(true, x, y, width, height, { 0, 0, 0, 255 }, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 1, width - 2, height - 2, { 20, 20, 20, 255 }, tab)
		Draw:MenuOutlinedRect(true, x + 2, y + 2, width - 3, 1, { 127, 72, 163, 255 }, tab)
		table.insert(menu.clrs.norm, tab[#tab])
		Draw:MenuOutlinedRect(true, x + 2, y + 3, width - 3, 1, { 87, 32, 123, 255 }, tab)
		table.insert(menu.clrs.dark, tab[#tab])
		Draw:MenuOutlinedRect(true, x + 2, y + 4, width - 3, 1, { 20, 20, 20, 255 }, tab)

		--{35, 35, 35, 255}

		Draw:MenuFilledRect(true, x + 2, y + 5, width - 4, 18, { 30, 30, 30, 255 }, tab)
		Draw:MenuFilledRect(true, x + 2, y + 21, width - 4, 2, { 20, 20, 20, 255 }, tab)

		local selected = {}
		for i = 0, 8 do
			Draw:MenuFilledRect(true, x + 2, y + 5 + (i * 2), width - 159, 2, { 45, 45, 45, 255 }, tab)
			tab[#tab].Color = ColorRange(
				i,
				{ [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 8, color = RGB(35, 35, 35) } }
			)
			table.insert(selected, { postable = #menu.postable, drawn = tab[#tab] })
		end

		local length = 2
		local selected_pos = {}
		local click_pos = {}
		local nametext = {}
		for i, v in ipairs(names) do
			Draw:MenuBigText(v, true, false, x + 4 + length, y + 5, tab)
			if i == 1 then
				tab[#tab].Color = RGB(255, 255, 255)
			else
				tab[#tab].Color = RGB(170, 170, 170)
			end
			table.insert(nametext, tab[#tab])

			Draw:MenuFilledRect(true, x + length + tab[#tab].TextBounds.X + 8, y + 5, 2, 16, { 20, 20, 20, 255 }, tab)
			table.insert(selected_pos, { pos = x + length, length = tab[#tab - 1].TextBounds.X + 8 })
			table.insert(click_pos, {
				x = x + length,
				y = y + 5,
				width = tab[#tab - 1].TextBounds.X + 8,
				height = 18,
				name = v,
				num = i,
			})
			length += tab[#tab - 1].TextBounds.X + 10
		end

		local settab = 1
		for k, v in pairs(selected) do
			menu.postable[v.postable][2] = selected_pos[settab].pos
			v.drawn.Size = Vector2.new(selected_pos[settab].length, 2)
		end

		return { bar = selected, barpos = selected_pos, click_pos = click_pos, nametext = nametext }

		--Draw:MenuBigText(str, true, false, x + 6, y + 5, tab)
	end

	function Draw:Toggle(name, value, unsafe, x, y, tab)
		Draw:MenuOutlinedRect(true, x, y, 12, 12, { 30, 30, 30, 255 }, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 1, 10, 10, { 0, 0, 0, 255 }, tab)

		local temptable = {}
		for i = 0, 3 do
			Draw:MenuFilledRect(true, x + 2, y + 2 + (i * 2), 8, 2, { 0, 0, 0, 255 }, tab)
			table.insert(temptable, tab[#tab])
			if value then
				tab[#tab].Color = ColorRange(i, {
					[1] = { start = 0, color = RGB(menu.mc[1], menu.mc[2], menu.mc[3]) },
					[2] = { start = 3, color = RGB(menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40) },
				})
			else
				tab[#tab].Color = ColorRange(i, {
					[1] = { start = 0, color = RGB(50, 50, 50) },
					[2] = { start = 3, color = RGB(30, 30, 30) },
				})
			end
		end

		Draw:MenuBigText(name, true, false, x + 16, y - 1, tab)
		if unsafe == true then
			tab[#tab].Color = RGB(245, 239, 120)
		end
		table.insert(temptable, tab[#tab])
		return temptable
	end

	function Draw:Keybind(key, x, y, tab)
		local temptable = {}
		Draw:MenuFilledRect(true, x, y, 44, 16, { 25, 25, 25, 255 }, tab)
		Draw:MenuBigText(KeyEnumToName(key), true, true, x + 22, y + 1, tab)
		table.insert(temptable, tab[#tab])
		Draw:MenuOutlinedRect(true, x, y, 44, 16, { 30, 30, 30, 255 }, tab)
		table.insert(temptable, tab[#tab])
		Draw:MenuOutlinedRect(true, x + 1, y + 1, 42, 14, { 0, 0, 0, 255 }, tab)

		return temptable
	end

	function Draw:ColorPicker(color, x, y, tab)
		local temptable = {}

		Draw:MenuOutlinedRect(true, x, y, 28, 14, { 30, 30, 30, 255 }, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 1, 26, 12, { 0, 0, 0, 255 }, tab)

		Draw:MenuFilledRect(true, x + 2, y + 2, 24, 10, { color[1], color[2], color[3], 255 }, tab)
		table.insert(temptable, tab[#tab])
		Draw:MenuOutlinedRect(true, x + 2, y + 2, 24, 10, { color[1] - 40, color[2] - 40, color[3] - 40, 255 }, tab)
		table.insert(temptable, tab[#tab])
		Draw:MenuOutlinedRect(true, x + 3, y + 3, 22, 8, { color[1] - 40, color[2] - 40, color[3] - 40, 255 }, tab)
		table.insert(temptable, tab[#tab])

		return temptable
	end

	function Draw:Slider(name, stradd, value, minvalue, maxvalue, customvals, rounded, x, y, length, tab)
		Draw:MenuBigText(name, true, false, x, y - 3, tab)

		for i = 0, 3 do
			Draw:MenuFilledRect(true, x + 2, y + 14 + (i * 2), length - 4, 2, { 0, 0, 0, 255 }, tab)
			tab[#tab].Color = ColorRange(
				i,
				{ [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 3, color = RGB(30, 30, 30) } }
			)
		end

		local temptable = {}
		for i = 0, 3 do
			Draw:MenuFilledRect(
				true,
				x + 2,
				y + 14 + (i * 2),
				(length - 4) * ((value - minvalue) / (maxvalue - minvalue)),
				2,
				{ 0, 0, 0, 255 },
				tab
			)
			table.insert(temptable, tab[#tab])
			tab[#tab].Color = ColorRange(i, {
				[1] = { start = 0, color = RGB(menu.mc[1], menu.mc[2], menu.mc[3]) },
				[2] = { start = 3, color = RGB(menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40) },
			})
		end
		Draw:MenuOutlinedRect(true, x, y + 12, length, 12, { 30, 30, 30, 255 }, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 13, length - 2, 10, { 0, 0, 0, 255 }, tab)

		local textstr = ""

		if stradd == nil then
			stradd = ""
		end

		local decplaces = rounded and string.rep("0", math.log(1 / rounded) / math.log(10)) or 1
		if rounded and value == math.floor(value * decplaces) then
			textstr = tostring(value) .. "." .. decplaces .. stradd
		else
			textstr = tostring(value) .. stradd
		end

		Draw:MenuBigText(customvals[value] or textstr, true, true, x + (length * 0.5), y + 11, tab)
		table.insert(temptable, tab[#tab])
		table.insert(temptable, stradd)
		return temptable
	end

	function Draw:Dropbox(name, value, values, x, y, length, tab)
		local temptable = {}
		Draw:MenuBigText(name, true, false, x, y - 3, tab)

		for i = 0, 7 do
			Draw:MenuFilledRect(true, x + 2, y + 14 + (i * 2), length - 4, 2, { 0, 0, 0, 255 }, tab)
			tab[#tab].Color = ColorRange(
				i,
				{ [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 7, color = RGB(35, 35, 35) } }
			)
		end

		Draw:MenuOutlinedRect(true, x, y + 12, length, 22, { 30, 30, 30, 255 }, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 13, length - 2, 20, { 0, 0, 0, 255 }, tab)

		Draw:MenuBigText(tostring(values[value]), true, false, x + 6, y + 16, tab)
		table.insert(temptable, tab[#tab])

		Draw:MenuBigText("-", true, false, x - 17 + length, y + 16, tab)
		table.insert(temptable, tab[#tab])

		return temptable
	end

	function Draw:Combobox(name, values, x, y, length, tab)
		local temptable = {}
		Draw:MenuBigText(name, true, false, x, y - 3, tab)

		for i = 0, 7 do
			Draw:MenuFilledRect(true, x + 2, y + 14 + (i * 2), length - 4, 2, { 0, 0, 0, 255 }, tab)
			tab[#tab].Color = ColorRange(
				i,
				{ [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 7, color = RGB(35, 35, 35) } }
			)
		end

		Draw:MenuOutlinedRect(true, x, y + 12, length, 22, { 30, 30, 30, 255 }, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 13, length - 2, 20, { 0, 0, 0, 255 }, tab)
		local textthing = ""
		for k, v in pairs(values) do
			if v[2] then
				if textthing == "" then
					textthing = v[1]
				else
					textthing ..= ", " .. v[1]
				end
			end
		end
		if string.len(textthing) > 25 then
			textthing = string_cut(textthing, 25)
		end
		textthing = textthing ~= "" and textthing or "None"
		Draw:MenuBigText(textthing, true, false, x + 6, y + 16, tab)
		table.insert(temptable, tab[#tab])

		Draw:MenuBigText("...", true, false, x - 27 + length, y + 16, tab)
		table.insert(temptable, tab[#tab])

		return temptable
	end

	function Draw:Button(name, x, y, length, tab)
		local temptable = {}

		for i = 0, 8 do
			Draw:MenuFilledRect(true, x + 2, y + 2 + (i * 2), length - 4, 2, { 0, 0, 0, 255 }, tab)
			tab[#tab].Color = ColorRange(
				i,
				{ [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 8, color = RGB(35, 35, 35) } }
			)
			table.insert(temptable, tab[#tab])
		end

		Draw:MenuOutlinedRect(true, x, y, length, 22, { 30, 30, 30, 255 }, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 1, length - 2, 20, { 0, 0, 0, 255 }, tab)
		temptable.text = Draw:MenuBigText(name, true, true, x + math.floor(length * 0.5), y + 4, tab)

		return temptable
	end

	function Draw:List(name, x, y, length, maxamount, columns, tab)
		local temptable = { uparrow = {}, downarrow = {}, liststuff = { rows = {}, words = {} } }

		for i, v in ipairs(name) do
			Draw:MenuBigText(
				v,
				true,
				false,
				(math.floor(length / columns) * i) - math.floor(length / columns) + 30,
				y - 3,
				tab
			)
		end

		Draw:MenuOutlinedRect(true, x, y + 12, length, 22 * maxamount + 4, { 30, 30, 30, 255 }, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 13, length - 2, 22 * maxamount + 2, { 0, 0, 0, 255 }, tab)

		Draw:MenuFilledRect(true, x + length - 7, y + 16, 1, 1, { menu.mc[1], menu.mc[2], menu.mc[3], 255 }, tab)
		table.insert(temptable.uparrow, tab[#tab])
		table.insert(menu.clrs.norm, tab[#tab])
		Draw:MenuFilledRect(true, x + length - 8, y + 17, 3, 1, { menu.mc[1], menu.mc[2], menu.mc[3], 255 }, tab)
		table.insert(temptable.uparrow, tab[#tab])
		table.insert(menu.clrs.norm, tab[#tab])
		Draw:MenuFilledRect(true, x + length - 9, y + 18, 5, 1, { menu.mc[1], menu.mc[2], menu.mc[3], 255 }, tab)
		table.insert(temptable.uparrow, tab[#tab])
		table.insert(menu.clrs.norm, tab[#tab])

		Draw:MenuFilledRect(
			true,
			x + length - 7,
			y + 16 + (22 * maxamount + 4) - 9,
			1,
			1,
			{ menu.mc[1], menu.mc[2], menu.mc[3], 255 },
			tab
		)
		table.insert(temptable.downarrow, tab[#tab])
		table.insert(menu.clrs.norm, tab[#tab])
		Draw:MenuFilledRect(
			true,
			x + length - 8,
			y + 16 + (22 * maxamount + 4) - 10,
			3,
			1,
			{ menu.mc[1], menu.mc[2], menu.mc[3], 255 },
			tab
		)
		table.insert(temptable.downarrow, tab[#tab])
		table.insert(menu.clrs.norm, tab[#tab])
		Draw:MenuFilledRect(
			true,
			x + length - 9,
			y + 16 + (22 * maxamount + 4) - 11,
			5,
			1,
			{ menu.mc[1], menu.mc[2], menu.mc[3], 255 },
			tab
		)
		table.insert(temptable.downarrow, tab[#tab])
		table.insert(menu.clrs.norm, tab[#tab])

		for i = 1, maxamount do
			temptable.liststuff.rows[i] = {}
			if i ~= maxamount then
				Draw:MenuOutlinedRect(true, x + 4, (y + 13) + (22 * i), length - 8, 2, { 20, 20, 20, 255 }, tab)
				table.insert(temptable.liststuff.rows[i], tab[#tab])
			end

			if columns ~= nil then
				for i1 = 1, columns - 1 do
					Draw:MenuOutlinedRect(
						true,
						x + math.floor(length / columns) * i1,
						(y + 13) + (22 * i) - 18,
						2,
						16,
						{ 20, 20, 20, 255 },
						tab
					)
					table.insert(temptable.liststuff.rows[i], tab[#tab])
				end
			end

			temptable.liststuff.words[i] = {}
			if columns ~= nil then
				for i1 = 1, columns do
					Draw:MenuBigText(
						"",
						true,
						false,
						(x + math.floor(length / columns) * i1) - math.floor(length / columns) + 5,
						(y + 13) + (22 * i) - 16,
						tab
					)
					table.insert(temptable.liststuff.words[i], tab[#tab])
				end
			else
				Draw:MenuBigText("", true, false, x + 5, (y + 13) + (22 * i) - 16, tab)
				table.insert(temptable.liststuff.words[i], tab[#tab])
			end
		end

		return temptable
	end

	function Draw:ImageWithText(size, image, text, x, y, tab)
		local temptable = {}
		Draw:MenuOutlinedRect(true, x, y, size + 4, size + 4, { 30, 30, 30, 255 }, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 1, size + 2, size + 2, { 0, 0, 0, 255 }, tab)
		Draw:MenuFilledRect(true, x + 2, y + 2, size, size, { 40, 40, 40, 255 }, tab)

		Draw:MenuBigText(text, true, false, x + size + 8, y, tab)
		table.insert(temptable, tab[#tab])

		Draw:MenuImage(true, BBOT_IMAGES[5], x + 2, y + 2, size, size, 1, tab)
		table.insert(temptable, tab[#tab])

		return temptable
	end

	function Draw:TextBox(name, text, x, y, length, tab)
		for i = 0, 8 do
			Draw:MenuFilledRect(true, x + 2, y + 2 + (i * 2), length - 4, 2, { 0, 0, 0, 255 }, tab)
			tab[#tab].Color = ColorRange(
				i,
				{ [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 8, color = RGB(35, 35, 35) } }
			)
		end

		Draw:MenuOutlinedRect(true, x, y, length, 22, { 30, 30, 30, 255 }, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 1, length - 2, 20, { 0, 0, 0, 255 }, tab)
		Draw:MenuBigText(text, true, false, x + 6, y + 4, tab)

		return tab[#tab]
	end
end

--funny graf
local networkin = {
	incoming = {},
	outgoing = {},
}

for i = 1, 21 do
	networkin.incoming[i] = 20
	networkin.outgoing[i] = 2
end
local lasttick = tick()

local infopos = 400

local graphs = {
	incoming = {
		pos = {
			x = 35,
			y = infopos,
		},
		sides = {},
		graph = {},
	},
	outgoing = {
		pos = {
			x = 35,
			y = infopos + 97,
		},
		sides = {},
		graph = {},
	},
	other = {},
}
--- incoming
Draw:OutlinedText(
	"incoming kbps: 20",
	2,
	false,
	graphs.incoming.pos.x - 1,
	graphs.incoming.pos.y - 15,
	13,
	false,
	{ 255, 255, 255, 255 },
	{ 10, 10, 10 },
	graphs.incoming.sides
)
Draw:OutlinedText(
	"80",
	2,
	false,
	graphs.incoming.pos.x - 21,
	graphs.incoming.pos.y - 7,
	13,
	false,
	{ 255, 255, 255, 255 },
	{ 10, 10, 10 },
	graphs.incoming.sides
)

Draw:FilledRect(
	false,
	graphs.incoming.pos.x - 1,
	graphs.incoming.pos.y - 1,
	222,
	82,
	{ 10, 10, 10, 50 },
	graphs.incoming.sides
)

Draw:Line(
	false,
	3,
	graphs.incoming.pos.x,
	graphs.incoming.pos.y - 1,
	graphs.incoming.pos.x,
	graphs.incoming.pos.y + 82,
	{ 20, 20, 20, 225 },
	graphs.incoming.sides
)
Draw:Line(
	false,
	3,
	graphs.incoming.pos.x,
	graphs.incoming.pos.y + 80,
	graphs.incoming.pos.x + 221,
	graphs.incoming.pos.y + 80,
	{ 20, 20, 20, 225 },
	graphs.incoming.sides
)
Draw:Line(
	false,
	3,
	graphs.incoming.pos.x,
	graphs.incoming.pos.y,
	graphs.incoming.pos.x - 6,
	graphs.incoming.pos.y,
	{ 20, 20, 20, 225 },
	graphs.incoming.sides
)

Draw:Line(
	false,
	1,
	graphs.incoming.pos.x,
	graphs.incoming.pos.y,
	graphs.incoming.pos.x,
	graphs.incoming.pos.y + 80,
	{ 255, 255, 255, 225 },
	graphs.incoming.sides
)
Draw:Line(
	false,
	1,
	graphs.incoming.pos.x,
	graphs.incoming.pos.y + 80,
	graphs.incoming.pos.x + 220,
	graphs.incoming.pos.y + 80,
	{ 255, 255, 255, 225 },
	graphs.incoming.sides
)
Draw:Line(
	false,
	1,
	graphs.incoming.pos.x,
	graphs.incoming.pos.y,
	graphs.incoming.pos.x - 5,
	graphs.incoming.pos.y,
	{ 255, 255, 255, 225 },
	graphs.incoming.sides
)

for i = 1, 20 do
	Draw:Line(false, 1, 10, 10, 10, 10, { 255, 255, 255, 225 }, graphs.incoming.graph)
end

Draw:Line(false, 1, 10, 10, 10, 10, { 68, 255, 0, 255 }, graphs.incoming.graph)
Draw:OutlinedText("avg: 20", 2, false, 20, 20, 13, false, { 68, 255, 0, 255 }, { 10, 10, 10 }, graphs.incoming.graph)

--- outgoing
Draw:OutlinedText(
	"outgoing kbps: 5",
	2,
	false,
	graphs.outgoing.pos.x - 1,
	graphs.outgoing.pos.y - 15,
	13,
	false,
	{ 255, 255, 255, 255 },
	{ 10, 10, 10 },
	graphs.outgoing.sides
)
Draw:OutlinedText(
	"10",
	2,
	false,
	graphs.outgoing.pos.x - 21,
	graphs.outgoing.pos.y - 7,
	13,
	false,
	{ 255, 255, 255, 255 },
	{ 10, 10, 10 },
	graphs.outgoing.sides
)

Draw:FilledRect(
	false,
	graphs.outgoing.pos.x - 1,
	graphs.outgoing.pos.y - 1,
	222,
	82,
	{ 10, 10, 10, 50 },
	graphs.outgoing.sides
)

Draw:Line(
	false,
	3,
	graphs.outgoing.pos.x,
	graphs.outgoing.pos.y - 1,
	graphs.outgoing.pos.x,
	graphs.outgoing.pos.y + 82,
	{ 20, 20, 20, 225 },
	graphs.outgoing.sides
)
Draw:Line(
	false,
	3,
	graphs.outgoing.pos.x,
	graphs.outgoing.pos.y + 80,
	graphs.outgoing.pos.x + 221,
	graphs.outgoing.pos.y + 80,
	{ 20, 20, 20, 225 },
	graphs.outgoing.sides
)
Draw:Line(
	false,
	3,
	graphs.outgoing.pos.x,
	graphs.outgoing.pos.y,
	graphs.outgoing.pos.x - 6,
	graphs.outgoing.pos.y,
	{ 20, 20, 20, 225 },
	graphs.outgoing.sides
)

Draw:Line(
	false,
	1,
	graphs.outgoing.pos.x,
	graphs.outgoing.pos.y,
	graphs.outgoing.pos.x,
	graphs.outgoing.pos.y + 80,
	{ 255, 255, 255, 225 },
	graphs.outgoing.sides
)
Draw:Line(
	false,
	1,
	graphs.outgoing.pos.x,
	graphs.outgoing.pos.y + 80,
	graphs.outgoing.pos.x + 220,
	graphs.outgoing.pos.y + 80,
	{ 255, 255, 255, 225 },
	graphs.outgoing.sides
)
Draw:Line(
	false,
	1,
	graphs.outgoing.pos.x,
	graphs.outgoing.pos.y,
	graphs.outgoing.pos.x - 5,
	graphs.outgoing.pos.y,
	{ 255, 255, 255, 225 },
	graphs.outgoing.sides
)

for i = 1, 20 do
	Draw:Line(false, 1, 10, 10, 10, 10, { 255, 255, 255, 225 }, graphs.outgoing.graph)
end

Draw:Line(false, 1, 10, 10, 10, 10, { 68, 255, 0, 255 }, graphs.outgoing.graph)
Draw:OutlinedText("avg: 20", 2, false, 20, 20, 13, false, { 68, 255, 0, 255 }, { 10, 10, 10 }, graphs.outgoing.graph)
-- the fuckin fps and stuff i think xDDDDDd

Draw:OutlinedText(
	"loading...",
	2,
	false,
	35,
	infopos + 180,
	13,
	false,
	{ 255, 255, 255, 255 },
	{ 10, 10, 10 },
	graphs.other
)

-- finish

local loadingthing = Draw:OutlinedText(
	"Loading...",
	2,
	true,
	math.floor(SCREEN_SIZE.x / 16),
	math.floor(SCREEN_SIZE.y / 16),
	13,
	true,
	{ 255, 50, 200, 255 },
	{ 0, 0, 0 }
)

function menu.Initialize(menutable)
	local bbmenu = {} -- this one is for the rendering n shi
	do
		Draw:MenuOutlinedRect(true, 0, 0, menu.w, menu.h, { 0, 0, 0, 255 }, bbmenu) -- first gradent or whatever
		Draw:MenuOutlinedRect(true, 1, 1, menu.w - 2, menu.h - 2, { 20, 20, 20, 255 }, bbmenu)
		Draw:MenuOutlinedRect(true, 2, 2, menu.w - 3, 1, { 127, 72, 163, 255 }, bbmenu)
		table.insert(menu.clrs.norm, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 2, 3, menu.w - 3, 1, { 87, 32, 123, 255 }, bbmenu)
		table.insert(menu.clrs.dark, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 2, 4, menu.w - 3, 1, { 20, 20, 20, 255 }, bbmenu)

		for i = 0, 19 do
			Draw:MenuFilledRect(true, 2, 5 + i, menu.w - 4, 1, { 20, 20, 20, 255 }, bbmenu)
			bbmenu[6 + i].Color = ColorRange(
				i,
				{ [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 20, color = RGB(35, 35, 35) } }
			)
		end
		Draw:MenuFilledRect(true, 2, 25, menu.w - 4, menu.h - 27, { 35, 35, 35, 255 }, bbmenu)

		Draw:MenuBigText(MenuName or "Bitch Bot", true, false, 6, 6, bbmenu)

		Draw:MenuOutlinedRect(true, 8, 22, menu.w - 16, menu.h - 30, { 0, 0, 0, 255 }, bbmenu) -- all this shit does the 2nd gradent
		Draw:MenuOutlinedRect(true, 9, 23, menu.w - 18, menu.h - 32, { 20, 20, 20, 255 }, bbmenu)
		Draw:MenuOutlinedRect(true, 10, 24, menu.w - 19, 1, { 127, 72, 163, 255 }, bbmenu)
		table.insert(menu.clrs.norm, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 10, 25, menu.w - 19, 1, { 87, 32, 123, 255 }, bbmenu)
		table.insert(menu.clrs.dark, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 10, 26, menu.w - 19, 1, { 20, 20, 20, 255 }, bbmenu)

		for i = 0, 14 do
			Draw:MenuFilledRect(true, 10, 27 + (i * 2), menu.w - 20, 2, { 45, 45, 45, 255 }, bbmenu)
			bbmenu[#bbmenu].Color = ColorRange(
				i,
				{ [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 15, color = RGB(35, 35, 35) } }
			)
		end
		Draw:MenuFilledRect(true, 10, 57, menu.w - 20, menu.h - 67, { 35, 35, 35, 255 }, bbmenu)
	end
	-- ok now the cool part :D
	--ANCHOR menu stuffz

	local tabz = {}
	for i = 1, #menutable do
		tabz[i] = {}
	end

	local tabs = {} -- i like tabby catz 🐱🐱🐱

	menu.multigroups = {}

	for k, v in pairs(menutable) do
		Draw:MenuFilledRect(
			true,
			10 + ((k - 1) * ((menu.w - 20) / #menutable)),
			27,
			((menu.w - 20) / #menutable),
			32,
			{ 30, 30, 30, 255 },
			bbmenu
		)
		Draw:MenuOutlinedRect(
			true,
			10 + ((k - 1) * ((menu.w - 20) / #menutable)),
			27,
			((menu.w - 20) / #menutable),
			32,
			{ 20, 20, 20, 255 },
			bbmenu
		)
		Draw:MenuBigText(
			v.name,
			true,
			true,
			math.floor(10 + ((k - 1) * ((menu.w - 20) / #menutable)) + (((menu.w - 20) / #menutable) * 0.5)),
			35,
			bbmenu
		)
		table.insert(tabs, { bbmenu[#bbmenu - 2], bbmenu[#bbmenu - 1], bbmenu[#bbmenu] })
		table.insert(menu.tabnames, v.name)

		menu.options[v.name] = {}
		menu.multigroups[v.name] = {}
		menu.mgrouptabz[v.name] = {}

		local y_offies = { left = 66, right = 66 }
		if v.content ~= nil then
			for k1, v1 in pairs(v.content) do
				if v1.autopos ~= nil then
					v1.width = menu.columns.width
					if v1.autopos == "left" then
						v1.x = menu.columns.left
						v1.y = y_offies.left
					elseif v1.autopos == "right" then
						v1.x = menu.columns.right
						v1.y = y_offies.right
					end
				end

				local groups = {}

				if type(v1.name) == "table" then
					groups = v1.name
				else
					table.insert(groups, v1.name)
				end

				local y_pos = 24

				for g_ind, g_name in ipairs(groups) do
					menu.options[v.name][g_name] = {}
					if type(v1.name) == "table" then
						menu.mgrouptabz[v.name][g_name] = {}
						menu.log_multi = { v.name, g_name }
					end

					local content = nil
					if type(v1.name) == "table" then
						y_pos = 28
						content = v1[g_ind].content
					else
						y_pos = 24
						content = v1.content
					end


					if content ~= nil then
						for k2, v2 in pairs(content) do
							if v2.type == TOGGLE then
								menu.options[v.name][g_name][v2.name] = {}
								local unsafe = false
								if v2.unsafe then
									unsafe = true
								end
								menu.options[v.name][g_name][v2.name][4] = Draw:Toggle(v2.name, v2.value, unsafe, v1.x + 8, v1.y + y_pos, tabz[k])
								menu.options[v.name][g_name][v2.name][1] = v2.value
								menu.options[v.name][g_name][v2.name][7] = v2.value
								menu.options[v.name][g_name][v2.name][2] = v2.type
								menu.options[v.name][g_name][v2.name][3] = { v1.x + 7, v1.y + y_pos - 1 }
								menu.options[v.name][g_name][v2.name][6] = unsafe
								menu.options[v.name][g_name][v2.name].tooltip = v2.tooltip or nil
								if v2.extra ~= nil then
									if v2.extra.type == KEYBIND then
										menu.options[v.name][g_name][v2.name][5] = {}
										menu.options[v.name][g_name][v2.name][5][4] = Draw:Keybind(
											v2.extra.key,
											v1.x + v1.width - 52,
											y_pos + v1.y - 2,
											tabz[k]
										)
										menu.options[v.name][g_name][v2.name][5][1] = v2.extra.key
										menu.options[v.name][g_name][v2.name][5][2] = v2.extra.type
										menu.options[v.name][g_name][v2.name][5][3] = { v1.x + v1.width - 52, y_pos + v1.y - 2 }
										menu.options[v.name][g_name][v2.name][5][5] = false
										menu.options[v.name][g_name][v2.name][5].toggletype = v2.extra.toggletype == nil and 1 or v2.extra.toggletype
										menu.options[v.name][g_name][v2.name][5].relvalue = false
										local event = event.new(("%s %s %s"):format(v.name, g_name, v2.name))
										event:connect(function(newval) 
											if menu:GetVal("Visuals", "Keybinds" ,"Log Keybinds") then 
												CreateNotification(("%s %s %s has been set to %s"):format(v.name, g_name, v2.name, newval and "true" or "false")) 
											end 
										end)
										menu.options[v.name][g_name][v2.name][5].event = event
										menu.options[v.name][g_name][v2.name][5].bind = table.insert(menu.keybinds, {
												menu.options[v.name][g_name][v2.name],
												tostring(v2.name),
												tostring(g_name),
												tostring(v.name),
											})
									elseif v2.extra.type == COLORPICKER then
										menu.options[v.name][g_name][v2.name][5] = {}
										menu.options[v.name][g_name][v2.name][5][4] = Draw:ColorPicker(
											v2.extra.color,
											v1.x + v1.width - 38,
											y_pos + v1.y - 1,
											tabz[k]
										)
										menu.options[v.name][g_name][v2.name][5][1] = v2.extra.color
										menu.options[v.name][g_name][v2.name][5][2] = v2.extra.type
										menu.options[v.name][g_name][v2.name][5][3] = { v1.x + v1.width - 38, y_pos + v1.y - 1 }
										menu.options[v.name][g_name][v2.name][5][5] = false
										menu.options[v.name][g_name][v2.name][5][6] = v2.extra.name
									elseif v2.extra.type == DOUBLE_COLORPICKER then
										menu.options[v.name][g_name][v2.name][5] = {}
										menu.options[v.name][g_name][v2.name][5][1] = {}
										menu.options[v.name][g_name][v2.name][5][1][1] = {}
										menu.options[v.name][g_name][v2.name][5][1][2] = {}
										menu.options[v.name][g_name][v2.name][5][2] = v2.extra.type
										for i = 1, 2 do
											menu.options[v.name][g_name][v2.name][5][1][i][4] = Draw:ColorPicker(
												v2.extra.color[i],
												v1.x + v1.width - 38 - ((i - 1) * 34),
												y_pos + v1.y - 1,
												tabz[k]
											)
											menu.options[v.name][g_name][v2.name][5][1][i][1] = v2.extra.color[i]
											menu.options[v.name][g_name][v2.name][5][1][i][3] = { v1.x + v1.width - 38 - ((i - 1) * 34), y_pos + v1.y - 1 }
											menu.options[v.name][g_name][v2.name][5][1][i][5] = false
											menu.options[v.name][g_name][v2.name][5][1][i][6] = v2.extra.name[i]
										end
									end
								end
								y_pos += 18
							elseif v2.type == SLIDER then
								menu.options[v.name][g_name][v2.name] = {}
								menu.options[v.name][g_name][v2.name][4] = Draw:Slider(
									v2.name,
									v2.stradd,
									v2.value,
									v2.minvalue,
									v2.maxvalue,
									v2.custom or {},
									v2.decimal,
									v1.x + 8,
									v1.y + y_pos,
									v1.width - 16,
									tabz[k]
								)
								menu.options[v.name][g_name][v2.name][1] = v2.value
								menu.options[v.name][g_name][v2.name][2] = v2.type
								menu.options[v.name][g_name][v2.name][3] = { v1.x + 7, v1.y + y_pos - 1, v1.width - 16 }
								menu.options[v.name][g_name][v2.name][5] = false
								menu.options[v.name][g_name][v2.name][6] = { v2.minvalue, v2.maxvalue }
								menu.options[v.name][g_name][v2.name][7] = { v1.x + 7 + v1.width - 38, v1.y + y_pos - 1 }
								menu.options[v.name][g_name][v2.name].decimal = v2.decimal == nil and nil or v2.decimal
								menu.options[v.name][g_name][v2.name].stepsize = v2.stepsize
								menu.options[v.name][g_name][v2.name].custom = v2.custom or {}

								y_pos += 30
							elseif v2.type == DROPBOX then
								menu.options[v.name][g_name][v2.name] = {}
								menu.options[v.name][g_name][v2.name][1] = v2.value
								menu.options[v.name][g_name][v2.name][2] = v2.type
								menu.options[v.name][g_name][v2.name][5] = false
								menu.options[v.name][g_name][v2.name][6] = v2.values

								if v2.x == nil then
									menu.options[v.name][g_name][v2.name][3] = { v1.x + 7, v1.y + y_pos - 1, v1.width - 16 }
									menu.options[v.name][g_name][v2.name][4] = Draw:Dropbox(
										v2.name,
										v2.value,
										v2.values,
										v1.x + 8,
										v1.y + y_pos,
										v1.width - 16,
										tabz[k]
									)
									y_pos += 40
								else
									menu.options[v.name][g_name][v2.name][3] = { v2.x + 7, v2.y - 1, v2.w }
									menu.options[v.name][g_name][v2.name][4] = Draw:Dropbox(v2.name, v2.value, v2.values, v2.x + 8, v2.y, v2.w, tabz[k])
								end
							elseif v2.type == COMBOBOX then
								menu.options[v.name][g_name][v2.name] = {}
								menu.options[v.name][g_name][v2.name][4] = Draw:Combobox(
										v2.name,
										v2.values,
										v1.x + 8,
										v1.y + y_pos,
										v1.width - 16,
										tabz[k]
									)
								menu.options[v.name][g_name][v2.name][1] = v2.values
								menu.options[v.name][g_name][v2.name][2] = v2.type
								menu.options[v.name][g_name][v2.name][3] = { v1.x + 7, v1.y + y_pos - 1, v1.width - 16 }
								menu.options[v.name][g_name][v2.name][5] = false
								y_pos += 40
							elseif v2.type == BUTTON then
								menu.options[v.name][g_name][v2.name] = {}
								menu.options[v.name][g_name][v2.name][1] = false
								menu.options[v.name][g_name][v2.name][2] = v2.type
								menu.options[v.name][g_name][v2.name].name = v2.name
								menu.options[v.name][g_name][v2.name].groupbox = g_name
								menu.options[v.name][g_name][v2.name].tab = v.name -- why is it all v, v1, v2 so ugly
								menu.options[v.name][g_name][v2.name].doubleclick = v2.doubleclick

								if v2.x == nil then
									menu.options[v.name][g_name][v2.name][3] = { v1.x + 7, v1.y + y_pos - 1, v1.width - 16 }
									menu.options[v.name][g_name][v2.name][4] = Draw:Button(v2.name, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
									y_pos += 28
								else
									menu.options[v.name][g_name][v2.name][3] = { v2.x + 7, v2.y - 1, v2.w }
									menu.options[v.name][g_name][v2.name][4] = Draw:Button(v2.name, v2.x + 8, v2.y, v2.w, tabz[k])
								end
							elseif v2.type == TEXTBOX then
								menu.options[v.name][g_name][v2.name] = {}
								menu.options[v.name][g_name][v2.name][4] = Draw:TextBox(v2.name, v2.text, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
								menu.options[v.name][g_name][v2.name][1] = v2.text
								menu.options[v.name][g_name][v2.name][2] = v2.type
								menu.options[v.name][g_name][v2.name][3] = { v1.x + 7, v1.y + y_pos - 1, v1.width - 16 }
								menu.options[v.name][g_name][v2.name][5] = false
								menu.options[v.name][g_name][v2.name][6] = v2.file and true or false
								y_pos += 28
							elseif v2.type == "list" then
								menu.options[v.name][g_name][v2.name] = {}
								menu.options[v.name][g_name][v2.name][4] = Draw:List(
									v2.multiname,
									v1.x + 8,
									v1.y + y_pos,
									v1.width - 16,
									v2.size,
									v2.columns,
									tabz[k]
								)
								menu.options[v.name][g_name][v2.name][1] = nil
								menu.options[v.name][g_name][v2.name][2] = v2.type
								menu.options[v.name][g_name][v2.name][3] = 1
								menu.options[v.name][g_name][v2.name][5] = {}
								menu.options[v.name][g_name][v2.name][6] = v2.size
								menu.options[v.name][g_name][v2.name][7] = v2.columns
								menu.options[v.name][g_name][v2.name][8] = { v1.x + 8, v1.y + y_pos, v1.width - 16 }
								y_pos += 22 + (22 * v2.size)
							elseif v2.type == IMAGE then
								menu.options[v.name][g_name][v2.name] = {}
								menu.options[v.name][g_name][v2.name][1] = Draw:ImageWithText(v2.size, nil, v2.text, v1.x + 8, v1.y + y_pos, tabz[k])
								menu.options[v.name][g_name][v2.name][2] = v2.type
							end
						end
					end

					menu.log_multi = nil
				end

				y_pos += 2

				if type(v1.name) ~= "table" then
					if v1.autopos == nil then
						Draw:CoolBox(v1.name, v1.x, v1.y, v1.width, v1.height, tabz[k])
					else
						if v1.autofill then
							y_pos = (menu.h - 17) - v1.y
						elseif v1.size ~= nil then
							y_pos = v1.size
						end
						Draw:CoolBox(v1.name, v1.x, v1.y, v1.width, y_pos, tabz[k])
						y_offies[v1.autopos] += y_pos + 6
					end
				else
					if v1.autofill then
						y_pos = (menu.h - 17) - v1.y
						y_offies[v1.autopos] += y_pos + 6
					elseif v1.size ~= nil then
						y_pos = v1.size
						y_offies[v1.autopos] += y_pos + 6
					end

					local drawn

					if v1.autopos == nil then
						drawn = Draw:CoolMultiBox(v1.name, v1.x, v1.y, v1.width, v1.height, tabz[k])
					else
						drawn = Draw:CoolMultiBox(v1.name, v1.x, v1.y, v1.width, y_pos, tabz[k])
					end

					local group_vals = {}

					for _i, _v in ipairs(v1.name) do
						if _i == 1 then
							group_vals[_v] = true
						else
							group_vals[_v] = false
						end
					end
					table.insert(menu.multigroups[v.name], { vals = group_vals, drawn = drawn })
				end
			end
		end
	end

	menu.list.addval = function(list, option)
		table.insert(list[5], option)
	end

	menu.list.removeval = function(list, optionnum)
		if list[1] == optionnum then
			list[1] = nil
		end
		table.remove(list[5], optionnum)
	end

	menu.list.removeall = function(list)
		list[5] = {}
		for k, v in pairs(list[4].liststuff) do
			for i, v1 in ipairs(v) do
				for i1, v2 in ipairs(v1) do
					v2.Visible = false
				end
			end
		end
	end

	menu.list.setval = function(list, value)
		list[1] = value
	end

	Draw:MenuOutlinedRect(true, 10, 59, menu.w - 20, menu.h - 69, { 20, 20, 20, 255 }, bbmenu)

	Draw:MenuOutlinedRect(true, 11, 58, ((menu.w - 20) / #menutable) - 2, 2, { 35, 35, 35, 255 }, bbmenu)
	local barguy = { bbmenu[#bbmenu], menu.postable[#menu.postable] }

	local function setActiveTab(slot)
		barguy[1].Position = Vector2.new(
			(menu.x + 11 + ((((menu.w - 20) / #menutable) - 2) * (slot - 1))) + ((slot - 1) * 2),
			menu.y + 58
		)
		barguy[2][2] = (11 + ((((menu.w - 20) / #menutable) - 2) * (slot - 1))) + ((slot - 1) * 2)
		barguy[2][3] = 58

		for k, v in pairs(tabs) do
			if k == slot then
				v[1].Visible = false
				v[3].Color = RGB(255, 255, 255)
			else
				v[3].Color = RGB(170, 170, 170)
				v[1].Visible = true
			end
		end

		for k, v in pairs(tabz) do
			if k == slot then
				for k1, v1 in pairs(v) do
					v1.Visible = true
				end
			else
				for k1, v1 in pairs(v) do
					v1.Visible = false
				end
			end
		end

		for k, v in pairs(menu.multigroups) do
			if menu.tabnames[menu.activetab] == k then
				for k1, v1 in pairs(v) do
					for k2, v2 in pairs(v1.vals) do
						for k3, v3 in pairs(menu.mgrouptabz[k][k2]) do
							v3.Visible = v2
						end
					end
				end
			end
		end
	end

	setActiveTab(menu.activetab)

	local plusminus = {}

	Draw:OutlinedText("_", 1, false, 10, 10, 14, false, { 225, 225, 225, 255 }, { 20, 20, 20 }, plusminus)
	Draw:OutlinedText("+", 1, false, 10, 10, 14, false, { 225, 225, 225, 255 }, { 20, 20, 20 }, plusminus)

	function menu:SetPlusMinus(value, x, y)
		for i, v in ipairs(plusminus) do
			if value == 0 then
				v.Visible = false
			else
				v.Visible = true
			end
		end

		if value ~= 0 then
			plusminus[1].Position = Vector2.new(x + 3 + menu.x, y - 5 + menu.y)
			plusminus[2].Position = Vector2.new(x + 13 + menu.x, y - 1 + menu.y)

			if value == 1 then
				for i, v in ipairs(plusminus) do
					v.Color = RGB(225, 225, 225)
					v.OutlineColor = RGB(20, 20, 20)
				end
			else
				for i, v in ipairs(plusminus) do
					if i + 1 == value then
						v.Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
					else
						v.Color = RGB(255, 255, 255)
					end
					v.OutlineColor = RGB(0, 0, 0)
				end
			end
		end
	end

	menu:SetPlusMinus(0, 20, 20)

	--DROP BOX THINGY
	local dropboxthingy = {}
	local dropboxtexty = {}

	Draw:OutlinedRect(false, 20, 20, 100, 22, { 20, 20, 20, 255 }, dropboxthingy)
	Draw:OutlinedRect(false, 21, 21, 98, 20, { 0, 0, 0, 255 }, dropboxthingy)
	Draw:FilledRect(false, 22, 22, 96, 18, { 45, 45, 45, 255 }, dropboxthingy)

	for i = 1, 30 do
		Draw:OutlinedText("", 2, false, 20, 20, 13, false, { 255, 255, 255, 255 }, { 0, 0, 0 }, dropboxtexty)
	end

	function menu:SetDropBox(visible, x, y, length, value, values)
		for k, v in pairs(dropboxthingy) do
			v.Visible = visible
		end

		local size = Vector2.new(length, 21 * (#values + 1) + 3)
		-- if y + size.y > SCREEN_SIZE.y then
		-- 	y = SCREEN_SIZE.y - size.y
		-- end
		-- if x + size.x > SCREEN_SIZE.x then
		-- 	x = SCREEN_SIZE.x - size.x
		-- end
		-- if y < 0 then
		-- 	y = 0
		-- end
		-- if x < 0 then
		-- 	x = 0
		-- end

		local pos = Vector2.new(x, y)
		dropboxthingy[1].Position = pos
		dropboxthingy[2].Position = Vector2.new(x + 1, y + 1)
		dropboxthingy[3].Position = Vector2.new(x + 2, y + 22)

		dropboxthingy[1].Size = size
		dropboxthingy[2].Size = Vector2.new(length - 2, (21 * (#values + 1)) + 1)
		dropboxthingy[3].Size = Vector2.new(length - 4, (21 * #values) + 1 - 1)


		
		if visible then
			for i = 1, #values do
				dropboxtexty[i].Position = Vector2.new(x + 6, y + 26 + ((i - 1) * 21))
				dropboxtexty[i].Visible = true
				dropboxtexty[i].Text = values[i]
				if i == value then
					dropboxtexty[i].Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
				else
					dropboxtexty[i].Color = RGB(255, 255, 255)
				end
			end
		else
			for k, v in pairs(dropboxtexty) do
				v.Visible = false
			end
		end
		return pos
	end

	local function set_comboboxthingy(visible, x, y, length, values)
		for k, v in pairs(dropboxthingy) do
			v.Visible = visible
		end
		local size = Vector2.new(length, 22 * (#values + 1) + 2)

		if y + size.y > SCREEN_SIZE.y then
			y = SCREEN_SIZE.y - size.y
		end
		if x + size.x > SCREEN_SIZE.x then
			x = SCREEN_SIZE.x - size.x
		end
		if y < 0 then
			y = 0
		end
		if x < 0 then
			x = 0
		end
		local pos = Vector2.new(x,y)
		dropboxthingy[1].Position = pos
		dropboxthingy[2].Position = Vector2.new(x + 1, y + 1)
		dropboxthingy[3].Position = Vector2.new(x + 2, y + 22)

		dropboxthingy[1].Size = size
		dropboxthingy[2].Size = Vector2.new(length - 2, (22 * (#values + 1)))
		dropboxthingy[3].Size = Vector2.new(length - 4, (22 * #values))

		if visible then
			for i = 1, #values do
				dropboxtexty[i].Position = Vector2.new(x + 6, y + 26 + ((i - 1) * 22))
				dropboxtexty[i].Visible = true
				dropboxtexty[i].Text = values[i][1]
				if values[i][2] then
					dropboxtexty[i].Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
				else
					dropboxtexty[i].Color = RGB(255, 255, 255)
				end
			end
		else
			for k, v in pairs(dropboxtexty) do
				v.Visible = false
			end
		end
		return pos
	end

	menu:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })

	--MODE SELECT THING
	local modeselect = {}

	Draw:OutlinedRect(false, 20, 20, 100, 22, { 20, 20, 20, 255 }, modeselect)
	Draw:OutlinedRect(false, 21, 21, 98, 20, { 0, 0, 0, 255 }, modeselect)
	Draw:FilledRect(false, 22, 22, 96, 18, { 45, 45, 45, 255 }, modeselect)

	local modeselecttext = { "Hold", "Toggle", "Hold Off", "Always" }
	for i = 1, 4 do
		Draw:OutlinedText(
			modeselecttext[i],
			2,
			false,
			20,
			20,
			13,
			false,
			{ 255, 255, 255, 255 },
			{ 0, 0, 0 },
			modeselect
		)
	end

	function menu:SetKeybindSelect(visible, x, y, value)
		for k, v in pairs(modeselect) do
			v.Visible = visible
		end

		if visible then
			modeselect[1].Position = Vector2.new(x, y)
			modeselect[2].Position = Vector2.new(x + 1, y + 1)
			modeselect[3].Position = Vector2.new(x + 2, y + 2)

			modeselect[1].Size = Vector2.new(70, 22 * 4 - 1)
			modeselect[2].Size = Vector2.new(70 - 2, 22 * 4 - 3)
			modeselect[3].Size = Vector2.new(70 - 4, 22 * 4 - 5)

			for i = 1, 4 do
				modeselect[i + 3].Position = Vector2.new(x + 6, y + 4 + ((i - 1) * 21))
				if value == i then
					modeselect[i + 3].Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
				else
					modeselect[i + 3].Color = RGB(255, 255, 255)
				end
			end
		end
	end

	menu:SetKeybindSelect(false, 200, 400, 1)

	--COLOR PICKER
	local cp = {
		x = 400,
		y = 40,
		w = 280,
		h = 211,
		alpha = false,
		dragging_m = false,
		dragging_r = false,
		dragging_b = false,
		hsv = {
			h = 0,
			s = 0,
			v = 0,
			a = 0,
		},
		postable = {},
		drawings = {},
	}

	local function ColorpickerOutline(visible, pos_x, pos_y, width, height, clr, tablename) -- doing all this shit to make it easier for me to make this beat look nice and shit ya fell dog :dog_head:
		Draw:OutlinedRect(visible, pos_x + cp.x, pos_y + cp.y, width, height, clr, tablename)
		table.insert(cp.postable, { tablename[#tablename], pos_x, pos_y })
	end

	local function ColorpickerRect(visible, pos_x, pos_y, width, height, clr, tablename)
		Draw:FilledRect(visible, pos_x + cp.x, pos_y + cp.y, width, height, clr, tablename)
		table.insert(cp.postable, { tablename[#tablename], pos_x, pos_y })
	end

	local function ColorpickerImage(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
		Draw:Image(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
		table.insert(cp.postable, { tablename[#tablename], pos_x, pos_y })
	end

	local function ColorpickerText(text, visible, centered, pos_x, pos_y, tablename)
		Draw:OutlinedText(
			text,
			2,
			visible,
			pos_x + cp.x,
			pos_y + cp.y,
			13,
			centered,
			{ 255, 255, 255, 255 },
			{ 0, 0, 0 },
			tablename
		)
		table.insert(cp.postable, { tablename[#tablename], pos_x, pos_y })
	end

	ColorpickerRect(false, 1, 1, cp.w, cp.h, { 35, 35, 35, 255 }, cp.drawings)
	ColorpickerOutline(false, 1, 1, cp.w, cp.h, { 0, 0, 0, 255 }, cp.drawings)
	ColorpickerOutline(false, 2, 2, cp.w - 2, cp.h - 2, { 20, 20, 20, 255 }, cp.drawings)
	ColorpickerOutline(false, 3, 3, cp.w - 3, 1, { 127, 72, 163, 255 }, cp.drawings)
	table.insert(menu.clrs.norm, cp.drawings[#cp.drawings])
	ColorpickerOutline(false, 3, 4, cp.w - 3, 1, { 87, 32, 123, 255 }, cp.drawings)
	table.insert(menu.clrs.dark, cp.drawings[#cp.drawings])
	ColorpickerOutline(false, 3, 5, cp.w - 3, 1, { 20, 20, 20, 255 }, cp.drawings)
	ColorpickerText("color picker :D", false, false, 7, 6, cp.drawings)

	ColorpickerText("x", false, false, 268, 4, cp.drawings)

	ColorpickerOutline(false, 10, 23, 160, 160, { 30, 30, 30, 255 }, cp.drawings)
	ColorpickerOutline(false, 11, 24, 158, 158, { 0, 0, 0, 255 }, cp.drawings)
	ColorpickerRect(false, 12, 25, 156, 156, { 0, 0, 0, 255 }, cp.drawings)
	local maincolor = cp.drawings[#cp.drawings]
	ColorpickerImage(false, BBOT_IMAGES[1], 12, 25, 156, 156, 1, cp.drawings)

	--https://i.imgur.com/jG3NjxN.png
	local alphabar = {}
	ColorpickerOutline(false, 10, 189, 160, 14, { 30, 30, 30, 255 }, cp.drawings)
	table.insert(alphabar, cp.drawings[#cp.drawings])
	ColorpickerOutline(false, 11, 190, 158, 12, { 0, 0, 0, 255 }, cp.drawings)
	table.insert(alphabar, cp.drawings[#cp.drawings])
	ColorpickerImage(false, BBOT_IMAGES[2], 12, 191, 159, 10, 1, cp.drawings)
	table.insert(alphabar, cp.drawings[#cp.drawings])

	ColorpickerOutline(false, 176, 23, 14, 160, { 30, 30, 30, 255 }, cp.drawings)
	ColorpickerOutline(false, 177, 24, 12, 158, { 0, 0, 0, 255 }, cp.drawings)
	--https://i.imgur.com/2Ty4u2O.png
	ColorpickerImage(false, BBOT_IMAGES[3], 178, 25, 10, 156, 1, cp.drawings)

	ColorpickerText("New Color", false, false, 198, 23, cp.drawings)
	ColorpickerOutline(false, 197, 37, 75, 40, { 30, 30, 30, 255 }, cp.drawings)
	ColorpickerOutline(false, 198, 38, 73, 38, { 0, 0, 0, 255 }, cp.drawings)
	ColorpickerImage(false, BBOT_IMAGES[4], 199, 39, 71, 36, 1, cp.drawings)

	ColorpickerRect(false, 199, 39, 71, 36, { 255, 0, 0, 255 }, cp.drawings)
	local newcolor = cp.drawings[#cp.drawings]

	ColorpickerText("copy", false, true, 198 + 36, 41, cp.drawings)
	ColorpickerText("paste", false, true, 198 + 37, 56, cp.drawings)
	local newcopy = { cp.drawings[#cp.drawings - 1], cp.drawings[#cp.drawings] }

	ColorpickerText("Old Color", false, false, 198, 77, cp.drawings)
	ColorpickerOutline(false, 197, 91, 75, 40, { 30, 30, 30, 255 }, cp.drawings)
	ColorpickerOutline(false, 198, 92, 73, 38, { 0, 0, 0, 255 }, cp.drawings)
	ColorpickerImage(false, BBOT_IMAGES[4], 199, 93, 71, 36, 1, cp.drawings)

	ColorpickerRect(false, 199, 93, 71, 36, { 255, 0, 0, 255 }, cp.drawings)
	local oldcolor = cp.drawings[#cp.drawings]

	ColorpickerText("copy", false, true, 198 + 36, 103, cp.drawings)
	local oldcopy = { cp.drawings[#cp.drawings] }

	--ColorpickerRect(false, 197, cp.h - 25, 75, 20, {30, 30, 30, 255}, cp.drawings)
	ColorpickerText("[ Apply ]", false, true, 235, cp.h - 23, cp.drawings)
	local applytext = cp.drawings[#cp.drawings]

	local function set_newcolor(r, g, b, a)
		newcolor.Color = RGB(r, g, b)
		if a ~= nil then
			newcolor.Transparency = a / 255
		else
			newcolor.Transparency = 1
		end
	end

	local function set_oldcolor(r, g, b, a)
		oldcolor.Color = RGB(r, g, b)
		cp.oldcolor = oldcolor.Color
		cp.oldcoloralpha = a
		if a ~= nil then
			oldcolor.Transparency = a / 255
		else
			oldcolor.Transparency = 1
		end
	end
	-- all this color picker shit is disgusting, why can't it be in it's own fucking scope. these are all global
	local dragbar_r = {}
	Draw:OutlinedRect(true, 30, 30, 16, 5, { 0, 0, 0, 255 }, cp.drawings)
	table.insert(dragbar_r, cp.drawings[#cp.drawings])
	Draw:OutlinedRect(true, 31, 31, 14, 3, { 255, 255, 255, 255 }, cp.drawings)
	table.insert(dragbar_r, cp.drawings[#cp.drawings])

	local dragbar_b = {}
	Draw:OutlinedRect(true, 30, 30, 5, 16, { 0, 0, 0, 255 }, cp.drawings)
	table.insert(dragbar_b, cp.drawings[#cp.drawings])
	table.insert(alphabar, cp.drawings[#cp.drawings])
	Draw:OutlinedRect(true, 31, 31, 3, 14, { 255, 255, 255, 255 }, cp.drawings)
	table.insert(dragbar_b, cp.drawings[#cp.drawings])
	table.insert(alphabar, cp.drawings[#cp.drawings])

	local dragbar_m = {}
	Draw:OutlinedRect(true, 30, 30, 5, 5, { 0, 0, 0, 255 }, cp.drawings)
	table.insert(dragbar_m, cp.drawings[#cp.drawings])
	Draw:OutlinedRect(true, 31, 31, 3, 3, { 255, 255, 255, 255 }, cp.drawings)
	table.insert(dragbar_m, cp.drawings[#cp.drawings])

	function menu:SetDragBarR(x, y)
		dragbar_r[1].Position = Vector2.new(x, y)
		dragbar_r[2].Position = Vector2.new(x + 1, y + 1)
	end

	function menu:SetDragBarB(x, y)
		dragbar_b[1].Position = Vector2.new(x, y)
		dragbar_b[2].Position = Vector2.new(x + 1, y + 1)
	end

	function menu:SetDragBarM(x, y)
		dragbar_m[1].Position = Vector2.new(x, y)
		dragbar_m[2].Position = Vector2.new(x + 1, y + 1)
	end

	function menu:SetColorPicker(visible, color, value, alpha, text, x, y)
		for k, v in pairs(cp.drawings) do
			v.Visible = visible
		end
		cp.oldalpha = alpha
		if visible then
			cp.x = clamp(x, 0, SCREEN_SIZE.x - cp.w)
			cp.y = clamp(y, 0, SCREEN_SIZE.y - cp.h)
			for k, v in pairs(cp.postable) do
				v[1].Position = Vector2.new(cp.x + v[2], cp.y + v[3])
			end

			local tempclr = RGB(color[1], color[2], color[3])
			local h, s, v = tempclr:ToHSV()
			cp.hsv.h = h
			cp.hsv.s = s
			cp.hsv.v = v

			menu:SetDragBarR(cp.x + 175, cp.y + 23 + math.floor((1 - h) * 156))
			menu:SetDragBarM(cp.x + 9 + math.floor(s * 156), cp.y + 23 + math.floor((1 - v) * 156))
			if not alpha then
				set_newcolor(color[1], color[2], color[3])
				set_oldcolor(color[1], color[2], color[3])
				cp.alpha = false
				for k, v in pairs(alphabar) do
					v.Visible = false
				end
				cp.h = 191
				for i = 1, 2 do
					cp.drawings[i].Size = Vector2.new(cp.w, cp.h)
				end
				cp.drawings[3].Size = Vector2.new(cp.w - 2, cp.h - 2)
			else
				cp.hsv.a = color[4]
				cp.alpha = true
				set_newcolor(color[1], color[2], color[3], color[4])
				set_oldcolor(color[1], color[2], color[3], color[4])
				cp.h = 211
				for i = 1, 2 do
					cp.drawings[i].Size = Vector2.new(cp.w, cp.h)
				end
				cp.drawings[3].Size = Vector2.new(cp.w - 2, cp.h - 2)
				menu:SetDragBarB(cp.x + 12 + math.floor(156 * (color[4] / 255)), cp.y + 188)
			end

			applytext.Position = Vector2.new(235 + cp.x, cp.y + cp.h - 23)
			maincolor.Color = Color3.fromHSV(h, 1, 1)
			cp.drawings[7].Text = text
		end
	end

	menu:SetColorPicker(false, { 255, 0, 0 }, nil, false, "", 0, 0)

	--TOOL TIP
	local tooltip = {
		x = 0,
		y = 0,
		time = 0,
		active = false,
		text = "This does this and that i guess\npooping 24/7",
		drawings = {},
		postable = {},
	}

	local function ttOutline(visible, pos_x, pos_y, width, height, clr, tablename)
		Draw:OutlinedRect(visible, pos_x + tooltip.x, pos_y + tooltip.y, width, height, clr, tablename)
		table.insert(tooltip.postable, { tablename[#tablename], pos_x, pos_y })
	end

	local function ttRect(visible, pos_x, pos_y, width, height, clr, tablename)
		Draw:FilledRect(visible, pos_x + tooltip.x, pos_y + tooltip.y, width, height, clr, tablename)
		table.insert(tooltip.postable, { tablename[#tablename], pos_x, pos_y })
	end

	local function ttText(text, visible, centered, pos_x, pos_y, tablename)
		Draw:OutlinedText(
			text,
			2,
			visible,
			pos_x + tooltip.x,
			pos_y + tooltip.y,
			13,
			centered,
			{ 255, 255, 255, 255 },
			{ 0, 0, 0 },
			tablename
		)
		table.insert(tooltip.postable, { tablename[#tablename], pos_x, pos_y })
	end

	ttRect(
		false,
		tooltip.x + 1,
		tooltip.y + 1,
		1,
		28,
		{ menu.mc[1], menu.mc[2], menu.mc[3], 255 },
		tooltip.drawings
	)
	ttRect(
		false,
		tooltip.x + 2,
		tooltip.y + 1,
		1,
		28,
		{ menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40, 255 },
		tooltip.drawings
	)
	ttOutline(false, tooltip.x, tooltip.y, 4, 30, { 20, 20, 20, 255 }, tooltip.drawings)
	ttRect(false, tooltip.x + 4, tooltip.y, 100, 30, { 40, 40, 40, 255 }, tooltip.drawings)
	ttOutline(false, tooltip.x - 1, tooltip.y - 1, 102, 32, { 0, 0, 0, 255 }, tooltip.drawings)
	ttOutline(false, tooltip.x + 3, tooltip.y, 102, 30, { 20, 20, 20, 255 }, tooltip.drawings)
	ttText(tooltip.text, false, false, tooltip.x + 7, tooltip.y + 1, tooltip.drawings)

	local bbmouse = {}
	function menu:SetToolTip(x, y, text, visible, dt)
		dt = dt or 0
		x = x or tooltip.x
		y = y or tooltip.y
		tooltip.x = x
		tooltip.y = y
		if tooltip.time < 1 and visible then
			if tooltip.time < -1 then
				tooltip.time = -1
			end
			tooltip.time += dt
		else
			tooltip.time -= dt
			if tooltip.time < -1 then
				tooltip.time = -1
			end
		end
		if not visible and tooltip.time < 0 then
			tooltip.time = -1
		end
		if tooltip.time > 1 then
			tooltip.time = 1
		end
		for k, v in ipairs(tooltip.drawings) do
			v.Visible = tooltip.time > 0
		end

		tooltip.active = visible
		if text then
			tooltip.drawings[7].Text = text
		end
		for k, v in pairs(tooltip.postable) do
			v[1].Position = Vector2.new(x + v[2], y + v[3])
			v[1].Transparency = math.min((0.3 + tooltip.time) ^ 3 - 1, menu.fade_amount or 1)
		end
		tooltip.drawings[1].Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
		tooltip.drawings[2].Color = RGB(menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40)

		local tb = tooltip.drawings[7].TextBounds

		tooltip.drawings[1].Size = Vector2.new(1, tb.Y + 3)
		tooltip.drawings[2].Size = Vector2.new(1, tb.Y + 3)
		tooltip.drawings[3].Size = Vector2.new(4, tb.Y + 5)
		tooltip.drawings[4].Size = Vector2.new(tb.X + 6, tb.Y + 5)
		tooltip.drawings[5].Size = Vector2.new(tb.X + 12, tb.Y + 7)
		tooltip.drawings[6].Size = Vector2.new(tb.X + 7, tb.Y + 5)
		if bbmouse[#bbmouse] then
			bbmouse[#bbmouse].Visible = visible
			bbmouse[#bbmouse].Transparency = 1 - tooltip.time
		end
	end

	menu:SetToolTip(500, 500, "", false)

	-- mouse shiz
	local mousie = {
		x = 100,
		y = 240,
	}
	Draw:Triangle(
		true,
		true,
		{ mousie.x, mousie.y },
		{ mousie.x, mousie.y + 15 },
		{ mousie.x + 10, mousie.y + 10 },
		{ 127, 72, 163, 255 },
		bbmouse
	)
	table.insert(menu.clrs.norm, bbmouse[#bbmouse])
	Draw:Triangle(
		true,
		false,
		{ mousie.x, mousie.y },
		{ mousie.x, mousie.y + 15 },
		{ mousie.x + 10, mousie.y + 10 },
		{ 0, 0, 0, 255 },
		bbmouse
	)
	Draw:OutlinedText("", 2, false, 0, 0, 13, false, { 255, 255, 255, 255 }, { 15, 15, 15 }, bbmouse)
	Draw:OutlinedText("?", 2, false, 0, 0, 13, false, { 255, 255, 255, 255 }, { 15, 15, 15 }, bbmouse)

	local lastMousePos = Vector2.new()
	function menu:SetMousePosition(x, y)
		FireEvent("bb_mousemoved", lastMousePos ~= Vector2.new(x, y))
		for k = 1, #bbmouse do
			local v = bbmouse[k]
			if k ~= #bbmouse and k ~= #bbmouse - 1 then
				v.PointA = Vector2.new(x, y + 36)
				v.PointB = Vector2.new(x, y + 36 + 15)
				v.PointC = Vector2.new(x + 10, y + 46)
			else
				v.Position = Vector2.new(x + 10, y + 46)
			end
		end
		lastMousePos = Vector2.new(x, y)
	end

	function menu:SetColor(r, g, b)
		menu.watermark.rect[1].Color = RGB(r - 40, g - 40, b - 40)
		menu.watermark.rect[2].Color = RGB(r, g, b)

		for k, v in pairs(menu.clrs.norm) do
			v.Color = RGB(r, g, b)
		end
		for k, v in pairs(menu.clrs.dark) do
			v.Color = RGB(r - 40, g - 40, b - 40)
		end
		local menucolor = { r, g, b }
		for k, v in pairs(menu.options) do
			for k1, v1 in pairs(v) do
				for k2, v2 in pairs(v1) do
					if v2[2] == TOGGLE then
						if not v2[1] then
							for i = 0, 3 do
								v2[4][i + 1].Color = ColorRange(i, {
									[1] = { start = 0, color = RGB(50, 50, 50) },
									[2] = { start = 3, color = RGB(30, 30, 30) },
								})
							end
						else
							for i = 0, 3 do
								v2[4][i + 1].Color = ColorRange(i, {
									[1] = { start = 0, color = RGB(menucolor[1], menucolor[2], menucolor[3]) },
									[2] = {
										start = 3,
										color = RGB(menucolor[1] - 40, menucolor[2] - 40, menucolor[3] - 40),
									},
								})
							end
						end
					elseif v2[2] == SLIDER then
						for i = 0, 3 do
							v2[4][i + 1].Color = ColorRange(i, {
								[1] = { start = 0, color = RGB(menucolor[1], menucolor[2], menucolor[3]) },
								[2] = {
									start = 3,
									color = RGB(menucolor[1] - 40, menucolor[2] - 40, menucolor[3] - 40),
								},
							})
						end
					end
				end
			end
		end
	end

	local function UpdateConfigs()
		local configthing = menu.options["Settings"]["Configuration"]["Configs"]

		configthing[6] = GetConfigs()
		if configthing[1] > #configthing[6] then
			configthing[1] = #configthing[6]
		end
		configthing[4][1].Text = configthing[6][configthing[1]]
	end

	menu.keybind_open = nil

	menu.dropbox_open = nil

	menu.colorPickerOpen = false

	menu.textboxopen = nil

	local shooties = {}
	local isPlayerScoped = false

	function menu:InputBeganMenu(key) --ANCHOR menu input
		if key.KeyCode == Enum.KeyCode.Delete and not loadingthing.Visible then
			cp.dragging_m = false
			cp.dragging_r = false
			cp.dragging_b = false

			customChatSpam = {}
			customKillSay = {}
			local customtxt = readfile("bitchbot/chatspam.txt")
			for s in customtxt:gmatch("[^\n]+") do -- I'm Love String:Match
				table.insert(customChatSpam, s)
			end
			customtxt = readfile("bitchbot/killsay.txt")
			for s in customtxt:gmatch("[^\n]+") do -- I'm Love String:Match
				table.insert(customKillSay, s)
			end
			UpdateConfigs()
			if menu.open and not menu.fading then
				for k = 1, #menu.options do
					local v = menu.options[k]
					for k1, v1 in pairs(v) do
						for k2, v2 in pairs(v1) do
							if v2[2] == SLIDER and v2[5] then
								v2[5] = false
							elseif v2[2] == DROPBOX and v2[5] then
								v2[5] = false
							elseif v2[2] == COMBOBOX and v2[5] then
								v2[5] = false
							elseif v2[2] == TOGGLE then
								if v2[5] ~= nil then
									if v2[5][2] == KEYBIND and v2[5][5] then
										v2[5][4][2].Color = RGB(30, 30, 30)
										v2[5][5] = false
									elseif v2[5][2] == COLORPICKER and v2[5][5] then
										v2[5][5] = false
									end
								end
							elseif v2[2] == BUTTON then
								if v2[1] then
									for i = 0, 8 do
										v2[4][i + 1].Color = ColorRange(i, {
											[1] = { start = 0, color = RGB(50, 50, 50) },
											[2] = { start = 8, color = RGB(35, 35, 35) },
										})
									end
									v2[1] = false
								end
							end
						end
					end
				end
				menu.keybind_open = nil
				menu:SetKeybindSelect(false, 20, 20, 1)
				menu.dropbox_open = nil
				menu:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })
				menu.colorPickerOpen = nil
				menu:SetToolTip(nil, nil, nil, false)
				menu:SetColorPicker(false, { 255, 0, 0 }, nil, false, "hahaha", 400, 200)
			end
			if not menu.fading then
				menu.fading = true
				menu.fadestart = tick()
			end
		end

		if menu == nil then
			return
		end

		if menu.textboxopen then
			if key.KeyCode == Enum.KeyCode.Delete or key.KeyCode == Enum.KeyCode.Return then
				for k, v in pairs(menu.options) do
					for k1, v1 in pairs(v) do
						for k2, v2 in pairs(v1) do
							if v2[2] == TEXTBOX then
								if v2[5] then
									v2[5] = false
									v2[4].Color = RGB(255, 255, 255)
									menu.textboxopen = false
									v2[4].Text = v2[1]
								end
							end
						end
					end
				end
			end
		end

		if menu.open and not menu.fading then
			for k, v in pairs(menu.options) do
				for k1, v1 in pairs(v) do
					for k2, v2 in pairs(v1) do
						if v2[2] == TOGGLE then
							if v2[5] ~= nil then
								if v2[5][2] == KEYBIND and v2[5][5] and key.KeyCode.Value ~= 0 then
									v2[5][4][2].Color = RGB(30, 30, 30)
									v2[5][4][1].Text = KeyEnumToName(key.KeyCode)
									if KeyEnumToName(key.KeyCode) == "None" then
										v2[5][1] = nil
									else
										v2[5][1] = key.KeyCode
									end
									v2[5][5] = false
								end
							end
						elseif v2[2] == TEXTBOX then --ANCHOR TEXTBOXES
							if v2[5] then
								if not INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftControl) then
									if string.len(v2[1]) <= 28 then
										if table.find(textBoxLetters, KeyEnumToName(key.KeyCode)) then
											if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftShift) then
												v2[1] ..= string.upper(KeyEnumToName(key.KeyCode))
											else
												v2[1] ..= string.lower(KeyEnumToName(key.KeyCode))
											end
										elseif KeyEnumToName(key.KeyCode) == "Space" then
											v2[1] ..= " "
										elseif keymodifiernames[KeyEnumToName(key.KeyCode)] ~= nil then
											if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftShift) then
												v2[1] ..= KeyModifierToName(KeyEnumToName(key.KeyCode), v2[6])
											else
												v2[1] ..= KeyEnumToName(key.KeyCode)
											end
										elseif KeyEnumToName(key.KeyCode) == "Back" and v2[1] ~= "" then
											v2[1] = string.sub(v2[1], 0, #v2[1] - 1)
										end
									end
									v2[4].Text = v2[1] .. "|"
								end
							end
						end
					end
				end
			end
		end
	end

	function menu:InputBeganKeybinds(key) -- this is super shit because once we add mouse we need to change all this shit to be the contextaction stuff
		if INPUT_SERVICE:GetFocusedTextBox() or menu.textboxopen then
			return
		end
		for i = 1, #self.keybinds do
			local value = self.keybinds[i][1]
			if key.KeyCode == value[5][1] then
				value[5].lastvalue = value[5].relvalue
				if value[5].toggletype == 2 then
					value[5].relvalue = not value[5].relvalue
				elseif value[5].toggletype == 1 then
					value[5].relvalue = true
				elseif value[5].toggletype == 3 then
					value[5].relvalue = false
				end
			elseif value[5].toggletype == 4 then
				value[5].relvalue = true
			end
			if value[5].lastvalue ~= value[5].relvalue then
				value[5].event:fire(value[5].relvalue)
			end
		end
	end

	function menu:InputEndedKeybinds(key)
		for i = 1, #self.keybinds do
			local value = self.keybinds[i][1]
			value[5].lastvalue = value[5].relvalue
			if key.KeyCode == value[5][1] then
				if value[5].toggletype == 1 then
					value[5].relvalue = false
				elseif value[5].toggletype == 3 then
					value[5].relvalue = true
				end
			end
			if value[5].lastvalue ~= value[5].relvalue then
				value[5].event:fire(value[5].relvalue)
			end
		end
	end

	function menu:SetMenuPos(x, y)
		for k, v in pairs(menu.postable) do
			if v[1].Visible then
				v[1].Position = Vector2.new(x + v[2], y + v[3])
			end
		end
	end

	function menu:MouseInArea(x, y, width, height)
		return LOCAL_MOUSE.x > x and LOCAL_MOUSE.x < x + width and LOCAL_MOUSE.y > 36 + y and LOCAL_MOUSE.y < 36 + y + height
	end

	function menu:MouseInMenu(x, y, width, height)
		return LOCAL_MOUSE.x > menu.x + x and LOCAL_MOUSE.x < menu.x + x + width and LOCAL_MOUSE.y > menu.y - 36 + y and LOCAL_MOUSE.y < menu.y - 36 + y + height
	end

	function menu:MouseInColorPicker(x, y, width, height)
		return LOCAL_MOUSE.x > cp.x + x and LOCAL_MOUSE.x < cp.x + x + width and LOCAL_MOUSE.y > cp.y - 36 + y and LOCAL_MOUSE.y < cp.y - 36 + y + height
	end

	local keyz = {}
	for k, v in pairs(Enum.KeyCode:GetEnumItems()) do
		keyz[v.Value] = v
	end


	function menu:GetVal(tab, groupbox, name, ...)
		local args = { ... }

		local option = menu.options[tab][groupbox][name]
		if not option then print(tab, groupbox, name) end
		if args[1] == nil then
			if option[2] == TOGGLE then
				local lastval = option[7]
				option[7] = option[1]
				return option[1], lastval
			elseif option[2] ~= COMBOBOX then
				return option[1]
			else
				local temptable = {}
				for k = 1, #option[1] do
					local v = option[1][k]
					table.insert(temptable, v[2])
				end
				return temptable
			end
		else
			if args[1] == KEYBIND or args[1] == COLOR then
				if args[2] then
					return RGB(option[5][1][1], option[5][1][2], option[5][1][3])
				else
					return option[5][1]
				end
			elseif args[1] == COLOR1 then
				if args[2] then
					return RGB(option[5][1][1][1][1], option[5][1][1][1][2], option[5][1][1][1][3])
				else
					return option[5][1][1][1]
				end
			elseif args[1] == COLOR2 then
				if args[2] then
					return RGB(option[5][1][2][1][1], option[5][1][2][1][2], option[5][1][2][1][3])
				else
					return option[5][1][2][1]
				end
			end
		end
	end

	function menu:GetKey(tab, groupbox, name)
		local option = self.options[tab][groupbox][name][5]
		local return1, return2, return3
		if self:GetVal(tab, groupbox, name) then
			if option.toggletype ~= 0 then
				if option.lastvalue == nil then
					option.lastvalue = option.relvalue
				end
				return1, return2, return3 = option.relvalue, option.lastvalue, option.event
				option.lastvalue = option.relvalue
			end
		end
		return return1, return2, return3
	end

	function menu:SetKey(tab, groupbox, name, val)
		val = val or false
		local option = menu.options[tab][groupbox][name][5]
		if option.toggletype ~= 0 then
			option.lastvalue = option.relvalue
			option.relvalue = val
			if option.lastvalue ~= option.relvalue then
				option.event:fire(option.relvalue)
			end
		end
	end

	local menuElementTypes = { [TOGGLE] = "toggle", [SLIDER] = "slider", [DROPBOX] = "dropbox", [TEXTBOX] = "textbox" }
	local doubleclickDelay = 1
	local buttonsInQue = {}

	local function SaveCurSettings() --ANCHOR figgies
		local figgy = "BitchBot v2\nmade with <3 by nata and bitch\n\n" -- screw zarzel XD (and json and classy) 

		for k, v in next, menuElementTypes do
			figgy ..= v .. "s {\n"
			for k1, v1 in pairs(menu.options) do
				for k2, v2 in pairs(v1) do
					for k3, v3 in pairs(v2) do
						if v3[2] == k and k3 ~= "Configs" and k3 ~= "Player Status" and k3 ~= "ConfigName"
						then
							figgy ..= k1 .. "|" .. k2 .. "|" .. k3 .. "|" .. tostring(v3[1]) .. "\n"
						end
					end
				end
			end
			figgy = figgy .. "}\n"
		end
		figgy = figgy .. "comboboxes {\n"
		for k, v in pairs(menu.options) do
			for k1, v1 in pairs(v) do
				for k2, v2 in pairs(v1) do
					if v2[2] == COMBOBOX then
						local boolz = ""
						for k3, v3 in pairs(v2[1]) do
							boolz = boolz .. tostring(v3[2]) .. ", "
						end
						figgy = figgy .. k .. "|" .. k1 .. "|" .. k2 .. "|" .. boolz .. "\n"
					end
				end
			end
		end
		figgy = figgy .. "}\n"
		figgy = figgy .. "keybinds {\n"
		for k, v in pairs(menu.options) do
			for k1, v1 in pairs(v) do
				for k2, v2 in pairs(v1) do
					if v2[2] == TOGGLE then
						if v2[5] ~= nil then
							if v2[5][2] == KEYBIND then
								local toggletype = "|" .. tostring(v2[5].toggletype)

								if v2[5][1] == nil then
									figgy = figgy
										.. k
										.. "|"
										.. k1
										.. "|"
										.. k2
										.. "|nil"
										.. "|"
										.. tostring(v2[5].toggletype)
										.. "\n"
								else
									figgy = figgy
										.. k
										.. "|"
										.. k1
										.. "|"
										.. k2
										.. "|"
										.. tostring(v2[5][1].Value)
										.. "|"
										.. tostring(v2[5].toggletype)
										.. "\n"
								end
							end
						end
					end
				end
			end
		end
		figgy = figgy .. "}\n"
		figgy = figgy .. "colorpickers {\n"
		for k, v in pairs(menu.options) do
			for k1, v1 in pairs(v) do
				for k2, v2 in pairs(v1) do
					if v2[2] == TOGGLE then
						if v2[5] ~= nil then
							if v2[5][2] == COLORPICKER then
								local clrz = ""
								for k3, v3 in pairs(v2[5][1]) do
									clrz = clrz .. tostring(v3) .. ", "
								end
								figgy = figgy .. k .. "|" .. k1 .. "|" .. k2 .. "|" .. clrz .. "\n"
							end
						end
					end
				end
			end
		end
		figgy = figgy .. "}\n"
		figgy = figgy .. "double colorpickers {\n"
		for k, v in pairs(menu.options) do
			for k1, v1 in pairs(v) do
				for k2, v2 in pairs(v1) do
					if v2[2] == TOGGLE then
						if v2[5] ~= nil then
							if v2[5][2] == DOUBLE_COLORPICKER then
								local clrz1 = ""
								for k3, v3 in pairs(v2[5][1][1][1]) do
									clrz1 = clrz1 .. tostring(v3) .. ", "
								end
								local clrz2 = ""
								for k3, v3 in pairs(v2[5][1][2][1]) do
									clrz2 = clrz2 .. tostring(v3) .. ", "
								end
								figgy = figgy .. k .. "|" .. k1 .. "|" .. k2 .. "|" .. clrz1 .. "|" .. clrz2 .. "\n"
							end
						end
					end
				end
			end
		end
		figgy = figgy .. "}\n"

		return figgy
	end

	local function LoadConfig(loadedcfg)
		local lines = {}

		for s in loadedcfg:gmatch("[^\r\n]+") do
			table.insert(lines, s)
		end

		if lines[1] == "BitchBot v2" then
			local start = nil
			for i, v in next, lines do
				if v == "toggles {" then
					start = i
					break
				end
			end
			local end_ = nil
			for i, v in next, lines do
				if i > start and v == "}" then
					end_ = i
					break
				end
			end
			for i = 1, end_ - start - 1 do
				local tt = string.split(lines[i + start], "|")

				if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil
				then
					if tt[4] == "true" then
						menu.options[tt[1]][tt[2]][tt[3]][1] = true
					else
						menu.options[tt[1]][tt[2]][tt[3]][1] = false
					end
				end
			end

			local start = nil
			for i, v in next, lines do
				if v == "sliders {" then
					start = i
					break
				end
			end
			local end_ = nil
			for i, v in next, lines do
				if i > start and v == "}" then
					end_ = i
					break
				end
			end
			for i = 1, end_ - start - 1 do
				local tt = string.split(lines[i + start], "|")
				if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil
				then
					menu.options[tt[1]][tt[2]][tt[3]][1] = tonumber(tt[4])
				end
			end

			local start = nil
			for i, v in next, lines do
				if v == "dropboxs {" then
					start = i
					break
				end
			end
			local end_ = nil
			for i, v in next, lines do
				if i > start and v == "}" then
					end_ = i
					break
				end
			end
			for i = 1, end_ - start - 1 do
				local tt = string.split(lines[i + start], "|")

				if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil
				then
					local num = tonumber(tt[4])
					if num > #menu.options[tt[1]][tt[2]][tt[3]][6] then
						num = #menu.options[tt[1]][tt[2]][tt[3]][6]
					elseif num < 0 then
						num = 1
					end
					menu.options[tt[1]][tt[2]][tt[3]][1] = num
				end
			end

			local start = nil
			for i, v in next, lines do
				if v == "textboxs {" then
					start = i
					break
				end
			end
			if start ~= nil then
				local end_ = nil
				for i, v in next, lines do
					if i > start and v == "}" then
						end_ = i
						break
					end
				end
				for i = 1, end_ - start - 1 do
					local tt = string.split(lines[i + start], "|")
					if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil
					then
						menu.options[tt[1]][tt[2]][tt[3]][1] = tostring(tt[4])
					end
				end
			end

			local start = nil
			for i, v in next, lines do
				if v == "comboboxes {" then
					start = i
					break
				end
			end
			local end_ = nil
			for i, v in next, lines do
				if i > start and v == "}" then
					end_ = i
					break
				end
			end
			for i = 1, end_ - start - 1 do
				local tt = string.split(lines[i + start], "|")
				if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil
				then
					local subs = string.split(tt[4], ",")

					for i, v in ipairs(subs) do
						local opt = string.gsub(v, " ", "")
						if opt == "true" then
							menu.options[tt[1]][tt[2]][tt[3]][1][i][2] = true
						else
							menu.options[tt[1]][tt[2]][tt[3]][1][i][2] = false
						end
						if i == #subs - 1 then
							break
						end
					end
				end
			end

			local start = nil
			for i, v in next, lines do
				if v == "keybinds {" then
					start = i
					break
				end
			end
			local end_ = nil
			for i, v in next, lines do
				if i > start and v == "}" then
					end_ = i
					break
				end
			end
			for i = 1, end_ - start - 1 do
				local tt = string.split(lines[i + start], "|")
				if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]][5] ~= nil
				then
					if tt[5] ~= nil then
						local toggletype = clamp(tonumber(tt[5]), 1, 4)
						if menu.options[tt[1]][tt[2]][tt[3]][5].toggletype ~= 0 then
							menu.options[tt[1]][tt[2]][tt[3]][5].toggletype = toggletype
						end
					end

					if tt[4] == "nil" then
						menu.options[tt[1]][tt[2]][tt[3]][5][1] = nil
					else
						menu.options[tt[1]][tt[2]][tt[3]][5][1] = keyz[tonumber(tt[4])]
					end
				end
			end

			local start = nil
			for i, v in next, lines do
				if v == "colorpickers {" then
					start = i
					break
				end
			end
			local end_ = nil
			for i, v in next, lines do
				if i > start and v == "}" then
					end_ = i
					break
				end
			end
			for i = 1, end_ - start - 1 do
				local tt = string.split(lines[i + start], "|")
				if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil
				then
					local subs = string.split(tt[4], ",")

					if type(menu.options[tt[1]][tt[2]][tt[3]][5][1][1]) == "table" then
						continue
					end
					for i, v in ipairs(subs) do
						if menu.options[tt[1]][tt[2]][tt[3]][5][1][i] == nil then
							break
						end
						local opt = string.gsub(v, " ", "")
						menu.options[tt[1]][tt[2]][tt[3]][5][1][i] = tonumber(opt)
						if i == #subs - 1 then
							break
						end
					end
				
				end
			end

			local start = nil
			for i, v in next, lines do
				if v == "double colorpickers {" then
					start = i
					break
				end
			end
			local end_ = nil
			for i, v in next, lines do
				if i > start and v == "}" then
					end_ = i
					break
				end
			end
			for i = 1, end_ - start - 1 do
				local tt = string.split(lines[i + start], "|")
				if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil
				then
					local subs = { string.split(tt[4], ","), string.split(tt[5], ",") }

					for i, v in ipairs(subs) do
						if type(menu.options[tt[1]][tt[2]][tt[3]][5][1][i]) == "number" then
							break
						end
						for i1, v1 in ipairs(v) do
							
								
							if menu.options[tt[1]][tt[2]][tt[3]][5][1][i][1][i1] == nil then
								break
							end
							local opt = string.gsub(v1, " ", "")
							menu.options[tt[1]][tt[2]][tt[3]][5][1][i][1][i1] = tonumber(opt)
							if i1 == #v - 1 then
								break
							end
						end
					end
				end
			end

			for k, v in pairs(menu.options) do
				for k1, v1 in pairs(v) do
					for k2, v2 in pairs(v1) do
						if v2[2] == TOGGLE then
							if not v2[1] then
								for i = 0, 3 do
									v2[4][i + 1].Color = ColorRange(i, {
										[1] = { start = 0, color = RGB(50, 50, 50) },
										[2] = { start = 3, color = RGB(30, 30, 30) },
									})
								end
							else
								for i = 0, 3 do
									v2[4][i + 1].Color = ColorRange(i, {
										[1] = { start = 0, color = RGB(menu.mc[1], menu.mc[2], menu.mc[3]) },
										[2] = {
											start = 3,
											color = RGB(menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40),
										},
									})
								end
							end
							if v2[5] ~= nil then
								if v2[5][2] == KEYBIND then
									v2[5][4][2].Color = RGB(30, 30, 30)
									v2[5][4][1].Text = KeyEnumToName(v2[5][1])
								elseif v2[5][2] == COLORPICKER then
									v2[5][4][1].Color = RGB(v2[5][1][1], v2[5][1][2], v2[5][1][3])
									for i = 2, 3 do
										v2[5][4][i].Color = RGB(v2[5][1][1] - 40, v2[5][1][2] - 40, v2[5][1][3] - 40)
									end
								elseif v2[5][2] == DOUBLE_COLORPICKER then
									if type(v2[5][1][1]) == "table" then 
										for i, v3 in ipairs(v2[5][1]) do
											v3[4][1].Color = RGB(v3[1][1], v3[1][2], v3[1][3])
											for i1 = 2, 3 do
												v3[4][i1].Color = RGB(v3[1][1] - 40, v3[1][2] - 40, v3[1][3] - 40)
											end
										end
									end
								end
							end
						elseif v2[2] == SLIDER then
							if v2[1] < v2[6][1] then
								v2[1] = v2[6][1]
							elseif v2[1] > v2[6][2] then
								v2[1] = v2[6][2]
							end

							local decplaces = v2.decimal and string.rep("0", math.log(1 / v2.decimal) / math.log(10))
							if decplaces and math.abs(v2[1]) < v2.decimal then
								v2[1] = 0
							end
							v2[4][5].Text = v2.custom[v2[1]] or (v2[1] == math.floor(v2[1]) and v2.decimal) and tostring(v2[1]) .. "." .. decplaces .. v2[4][6] or tostring(v2[1]) .. v2[4][6]
							-- v2[4][5].Text = tostring(v2[1]).. v2[4][6]

							for i = 1, 4 do
								v2[4][i].Size = Vector2.new((v2[3][3] - 4) * ((v2[1] - v2[6][1]) / (v2[6][2] - v2[6][1])), 2)
							end
						elseif v2[2] == DROPBOX then
							if v2[6][v2[1]] == nil then
								v2[1] = 1
							end
							v2[4][1].Text = v2[6][v2[1]]
						elseif v2[2] == COMBOBOX then
							local textthing = ""
							for k3, v3 in pairs(v2[1]) do
								if v3[2] then
									if textthing == "" then
										textthing = v3[1]
									else
										textthing = textthing .. ", " .. v3[1]
									end
								end
							end
							textthing = textthing ~= "" and textthing or "None"
							if string.len(textthing) > 25 then
								textthing = string_cut(textthing, 25)
							end
							v2[4][1].Text = textthing
						elseif v2[2] == TEXTBOX then
							v2[4].Text = v2[1]
						end
					end
				end
			end
		end
	end
	function menu.saveconfig()
		local figgy = SaveCurSettings()
		writefile(
			"bitchbot/"
				.. menu.game
				.. "/"
				.. menu.options["Settings"]["Configuration"]["ConfigName"][1]
				.. ".bb",
			figgy
		)
		CreateNotification('Saved "' .. menu.options["Settings"]["Configuration"]["ConfigName"][1] .. '.bb"!')
		UpdateConfigs()
	end
	
	function menu.loadconfig()
		local configname = "bitchbot/"
			.. menu.game
			.. "/"
			.. menu.options["Settings"]["Configuration"]["ConfigName"][1]
			.. ".bb"
		if not isfile(configname) then
			CreateNotification(
				'"'
					.. menu.options["Settings"]["Configuration"]["ConfigName"][1]
					.. '.bb" is not a valid config.'
			)
			return
		end
	
		local curcfg = SaveCurSettings()
		local loadedcfg = readfile(configname)
	
		if pcall(LoadConfig, loadedcfg) then
			CreateNotification('Loaded "' .. menu.options["Settings"]["Configuration"]["ConfigName"][1] .. '.bb"!')
		else
			LoadConfig(curcfg)
			CreateNotification(
				'There was an issue loading "'
					.. menu.options["Settings"]["Configuration"]["ConfigName"][1]
					.. '.bb"'
			)
		end
	end

	local function buttonpressed(bp)
		if bp.doubleclick then
			if buttonsInQue[bp] and tick() - buttonsInQue[bp] < doubleclickDelay then
				buttonsInQue[bp] = 0
			else
				for button, time in next, buttonsInQue do
					buttonsInQue[button] = 0
				end
				buttonsInQue[bp] = tick()
				return
			end
		end
		FireEvent("bb_buttonpressed", bp.tab, bp.groupbox, bp.name)
		--ButtonPressed:Fire(bp.tab, bp.groupbox, bp.name)
		if bp == menu.options["Settings"]["Cheat Settings"]["Unload Cheat"] then
			menu.fading = true
			wait()
			menu:unload()
		elseif bp == menu.options["Settings"]["Cheat Settings"]["Set Clipboard Game ID"] then
			setclipboard(game.JobId)
		elseif bp == menu.options["Settings"]["Configuration"]["Save Config"] then
			menu.saveconfig()
		elseif bp == menu.options["Settings"]["Configuration"]["Delete Config"] then
			delfile(
				"bitchbot/"
					.. menu.game
					.. "/"
					.. menu.options["Settings"]["Configuration"]["ConfigName"][1]
					.. ".bb"
			)
			CreateNotification('Deleted "' .. menu.options["Settings"]["Configuration"]["ConfigName"][1] .. '.bb"!')
			UpdateConfigs()
		elseif bp == menu.options["Settings"]["Configuration"]["Load Config"] then
			menu.loadconfig()
		end
	end

	local function MouseButton2Event()
		if menu.colorPickerOpen or menu.dropbox_open then
			return
		end

		for k, v in pairs(menu.options) do
			if menu.tabnames[menu.activetab] == k then
				for k1, v1 in pairs(v) do
					local pass = true
					for k3, v3 in pairs(menu.multigroups) do
						if k == k3 then
							for k4, v4 in pairs(v3) do
								for k5, v5 in pairs(v4.vals) do
									if k1 == k5 then
										pass = v5
									end
								end
							end
						end
					end

					if pass then
						for k2, v2 in pairs(v1) do --ANCHOR more menu bs
							if v2[2] == TOGGLE then
								if v2[5] ~= nil then
									if v2[5][2] == KEYBIND then
										if menu:MouseInMenu(v2[5][3][1], v2[5][3][2], 44, 16) then
											if menu.keybind_open ~= v2 and v2[5].toggletype ~= 0 then
												menu.keybind_open = v2
												menu:SetKeybindSelect(
													true,
													v2[5][3][1] + menu.x,
													v2[5][3][2] + 16 + menu.y,
													v2[5].toggletype
												)
											else
												menu.keybind_open = nil
												menu:SetKeybindSelect(false, 20, 20, 1)
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	local function menucolor()
		if menu.open then
			if menu:GetVal("Settings", "Cheat Settings", "Menu Accent") then
				local clr = menu:GetVal("Settings", "Cheat Settings", "Menu Accent", COLOR, true)
				menu.mc = { clr.R * 255, clr.G * 255, clr.B * 255 }
			else
				menu.mc = { 127, 72, 163 }
			end
			menu:SetColor(menu.mc[1], menu.mc[2], menu.mc[3])

			local wme = menu:GetVal("Settings", "Cheat Settings", "Watermark")
			for k, v in pairs(menu.watermark.rect) do
				v.Visible = wme
			end
			menu.watermark.text[1].Visible = wme
		end
	end
	local function MouseButton1Event() --ANCHOR menu mouse down func
		menu.dropbox_open = nil
		menu.textboxopen = false

		menu:SetKeybindSelect(false, 20, 20, 1)
		if menu.keybind_open then
			local key = menu.keybind_open
			local foundkey = false
			for i = 1, 4 do
				if menu:MouseInMenu(key[5][3][1], key[5][3][2] + 16 + ((i - 1) * 21), 70, 21) then
					foundkey = true
					menu.keybind_open[5].toggletype = i
					menu.keybind_open[5].relvalue = false
				end
			end
			menu.keybind_open = nil
			if foundkey then
				return
			end
		end

		for k, v in pairs(menu.options) do
			for k1, v1 in pairs(v) do
				for k2, v2 in pairs(v1) do
					if v2[2] == DROPBOX and v2[5] then
						if not menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[6] + 1) + 3) then
							menu:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })
							v2[5] = false
						else
							menu.dropbox_open = v2
						end
					end
					if v2[2] == COMBOBOX and v2[5] then
						if not menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[1] + 1) + 3) then
							menu:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })
							v2[5] = false
						else
							menu.dropbox_open = v2
						end
					end
					if v2[2] == TOGGLE then
						if v2[5] ~= nil then
							if v2[5][2] == KEYBIND then
								if v2[5][5] == true then
									v2[5][4][2].Color = RGB(30, 30, 30)
									v2[5][5] = false
								end
							elseif v2[5][2] == COLORPICKER then
								if v2[5][5] == true then
									if not menu:MouseInColorPicker(0, 0, cp.w, cp.h) then
										if menu.colorPickerOpen then
											
											local tempclr = cp.oldcolor
											menu.colorPickerOpen[4][1].Color = tempclr
											for i = 2, 3 do
												menu.colorPickerOpen[4][i].Color = RGB(
													math.floor(tempclr.R * 255) - 40,
													math.floor(tempclr.G * 255) - 40,
													math.floor(tempclr.B * 255) - 40
												)
											end
											if cp.alpha then
												menu.colorPickerOpen[1] = {
													math.floor(tempclr.R * 255),
													math.floor(tempclr.G * 255),
													math.floor(tempclr.B * 255),
													cp.oldcoloralpha,
												}
											else
												menu.colorPickerOpen[1] = {
													math.floor(tempclr.R * 255),
													math.floor(tempclr.G * 255),
													math.floor(tempclr.B * 255),
												}
											end
										end
										menu:SetColorPicker(false, { 255, 0, 0 }, nil, false, "hahaha", 400, 200)
										v2[5][5] = false
										menu.colorPickerOpen = nil -- close colorpicker
									end
								end
							elseif v2[5][2] == DOUBLE_COLORPICKER then
								for k3, v3 in pairs(v2[5][1]) do
									if v3[5] == true then
										if not menu:MouseInColorPicker(0, 0, cp.w, cp.h) then
											if menu.colorPickerOpen then
												local tempclr = cp.oldcolor
												menu.colorPickerOpen[4][1].Color = tempclr
												for i = 2, 3 do
													menu.colorPickerOpen[4][i].Color = RGB(
														math.floor(tempclr.R * 255) - 40,
														math.floor(tempclr.G * 255) - 40,
														math.floor(tempclr.B * 255) - 40
													)
												end
												if cp.alpha then
													menu.colorPickerOpen[1] = {
														math.floor(tempclr.R * 255),
														math.floor(tempclr.G * 255),
														math.floor(tempclr.B * 255),
														cp.oldcoloralpha,
													}
												else
													menu.colorPickerOpen[1] = {
														math.floor(tempclr.R * 255),
														math.floor(tempclr.G * 255),
														math.floor(tempclr.B * 255),
													}
												end
											end
											menu:SetColorPicker(false, { 255, 0, 0 }, nil, false, "hahaha", 400, 200)
											v3[5] = false
											menu.colorPickerOpen = nil -- close colorpicker
											
										end
									end
								end
							end
						end
					end
					if v2[2] == TEXTBOX and v2[5] then
						v2[4].Color = RGB(255, 255, 255)
						v2[5] = false
						v2[4].Text = v2[1]
					end
				end
			end
		end
		for i = 1, #menutable do
			if menu:MouseInMenu(
					10 + ((i - 1) * math.floor((menu.w - 20) / #menutable)),
					27,
					math.floor((menu.w - 20) / #menutable),
					32
				)
			then
				menu.activetab = i
				setActiveTab(menu.activetab)
				menu:SetMenuPos(menu.x, menu.y)
				menu:SetToolTip(nil, nil, nil, false)
			end
		end
		if menu.colorPickerOpen then
			if menu:MouseInColorPicker(197, cp.h - 25, 75, 20) then
				--apply newcolor to oldcolor
				local tempclr = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
				menu.colorPickerOpen[4][1].Color = tempclr
				for i = 2, 3 do
					menu.colorPickerOpen[4][i].Color = RGB(
						math.floor(tempclr.R * 255) - 40,
						math.floor(tempclr.G * 255) - 40,
						math.floor(tempclr.B * 255) - 40
					)
				end
				if cp.alpha then
					menu.colorPickerOpen[1] = {
						math.floor(tempclr.R * 255),
						math.floor(tempclr.G * 255),
						math.floor(tempclr.B * 255),
						cp.hsv.a,
					}
				else
					menu.colorPickerOpen[1] = {
						math.floor(tempclr.R * 255),
						math.floor(tempclr.G * 255),
						math.floor(tempclr.B * 255),
					}
				end
				menu.colorPickerOpen = nil
				menu:SetColorPicker(false, { 255, 0, 0 }, nil, false, "hahaha", 400, 200)
			end
			if menu:MouseInColorPicker(264, 2, 14, 14) then
				-- x out
				local tempclr = cp.oldcolor
				menu.colorPickerOpen[4][1].Color = tempclr
				for i = 2, 3 do
					menu.colorPickerOpen[4][i].Color = RGB(
						math.floor(tempclr.R * 255) - 40,
						math.floor(tempclr.G * 255) - 40,
						math.floor(tempclr.B * 255) - 40
					)
				end
				if cp.alpha then
					menu.colorPickerOpen[1] = {
						math.floor(tempclr.R * 255),
						math.floor(tempclr.G * 255),
						math.floor(tempclr.B * 255),
						cp.oldcoloralpha,
					}
				else
					menu.colorPickerOpen[1] = {
						math.floor(tempclr.R * 255),
						math.floor(tempclr.G * 255),
						math.floor(tempclr.B * 255),
					}
				end
				menu.colorPickerOpen = nil
				menu:SetColorPicker(false, { 255, 0, 0 }, nil, false, "hahaha", 400, 200)
			end
			if menu:MouseInColorPicker(10, 23, 160, 160) then
				cp.dragging_m = true
				--set value and saturation
			elseif menu:MouseInColorPicker(176, 23, 14, 160) then
				cp.dragging_r = true
				--set hue
			elseif menu:MouseInColorPicker(10, 189, 160, 14) and cp.alpha then
				cp.dragging_b = true
				--set transparency
			end

			if menu:MouseInColorPicker(197, 37, 75, 20) then
				menu.copied_clr = newcolor.Color
				--copy newcolor
			elseif menu:MouseInColorPicker(197, 57, 75, 20) then
				--paste newcolor
				if menu.copied_clr ~= nil then
					local cpa = false
					local clrtable = { menu.copied_clr.R * 255, menu.copied_clr.G * 255, menu.copied_clr.B * 255 }
					if menu.colorPickerOpen[1][4] ~= nil then
						cpa = true
						table.insert(clrtable, menu.colorPickerOpen[1][4])
					end

					menu:SetColorPicker(true, clrtable, menu.colorPickerOpen, cpa, menu.colorPickerOpen[6], cp.x, cp.y)
					cp.oldclr = menu.colorPickerOpen[4][1].Color
					local oldclr = cp.oldclr
					if menu.colorPickerOpen[1][4] ~= nil then
						set_oldcolor(oldclr.R * 255, oldclr.G * 255, oldclr.B * 255, menu.colorPickerOpen[1][4])
					else
						set_oldcolor(oldclr.R * 255, oldclr.G * 255, oldclr.B * 255)
					end
				end
			end

			if menu:MouseInColorPicker(197, 91, 75, 40) then
				menu.copied_clr = oldcolor.Color --copy oldcolor
			end
		else
			for k, v in pairs(menu.multigroups) do
				if menu.tabnames[menu.activetab] == k then
					for k1, v1 in pairs(v) do
						local c_pos = v1.drawn.click_pos
						--local selected = v1.drawn.bar
						local selected_pos = v1.drawn.barpos

						for k2, v2 in pairs(v1.drawn.click_pos) do
							if menu:MouseInMenu(v2.x, v2.y, v2.width, v2.height) then
								for _k, _v in pairs(v1.vals) do
									if _k == v2.name then
										v1.vals[_k] = true
									else
										v1.vals[_k] = false
									end
								end

								local settab = v2.num
								for _k, _v in pairs(v1.drawn.bar) do
									menu.postable[_v.postable][2] = selected_pos[settab].pos
									_v.drawn.Size = Vector2.new(selected_pos[settab].length, 2)
								end

								for i, v in pairs(v1.drawn.nametext) do
									if i == v2.num then
										v.Color = RGB(255, 255, 255)
									else
										v.Color = RGB(170, 170, 170)
									end
								end

								menu:setMenuVisible(true)
								setActiveTab(menu.activetab)
								menu:SetMenuPos(menu.x, menu.y)
							end
						end
					end
				end
			end
			local newdropbox_open
			for k, v in pairs(menu.options) do
				if menu.tabnames[menu.activetab] == k then
					for k1, v1 in pairs(v) do
						local pass = true
						for k3, v3 in pairs(menu.multigroups) do
							if k == k3 then
								for k4, v4 in pairs(v3) do
									for k5, v5 in pairs(v4.vals) do
										if k1 == k5 then
											pass = v5
										end
									end
								end
							end
						end

						if pass then
							for k2, v2 in pairs(v1) do
								if v2[2] == TOGGLE and not menu.dropbox_open then
									if menu:MouseInMenu(v2[3][1], v2[3][2], 30 + v2[4][5].TextBounds.x, 16) then
										if v2[6] then
											if menu:GetVal(
													"Settings",
													"Cheat Settings",
													"Allow Unsafe Features"
												) and v2[1] == false
											then
												v2[1] = true
											else
												v2[1] = false
											end
										else
											v2[1] = not v2[1]
										end
										if not v2[1] then
											for i = 0, 3 do
												v2[4][i + 1].Color = ColorRange(i, {
													[1] = { start = 0, color = RGB(50, 50, 50) },
													[2] = { start = 3, color = RGB(30, 30, 30) },
												})
											end
										else
											for i = 0, 3 do
												v2[4][i + 1].Color = ColorRange(i, {
													[1] = {
														start = 0,
														color = RGB(menu.mc[1], menu.mc[2], menu.mc[3]),
													},
													[2] = {
														start = 3,
														color = RGB(
															menu.mc[1] - 40,
															menu.mc[2] - 40,
															menu.mc[3] - 40
														),
													},
												})
											end
										end
										--TogglePressed:Fire(k1, k2, v2)
										FireEvent("bb_togglepressed", k1, k2, v2)
									end
									if v2[5] ~= nil then
										if v2[5][2] == KEYBIND then
											if menu:MouseInMenu(v2[5][3][1], v2[5][3][2], 44, 16) then
												v2[5][4][2].Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
												v2[5][5] = true
											end
										elseif v2[5][2] == COLORPICKER then
											if menu:MouseInMenu(v2[5][3][1], v2[5][3][2], 28, 14) then
												v2[5][5] = true
												menu.colorPickerOpen = v2[5]
												menu.colorPickerOpen = v2[5]
												if v2[5][1][4] ~= nil then
													menu:SetColorPicker(
														true,
														v2[5][1],
														v2[5],
														true,
														v2[5][6],
														LOCAL_MOUSE.x,
														LOCAL_MOUSE.y + 36
													)
												else
													menu:SetColorPicker(
														true,
														v2[5][1],
														v2[5],
														false,
														v2[5][6],
														LOCAL_MOUSE.x,
														LOCAL_MOUSE.y + 36
													)
												end
											end
										elseif v2[5][2] == DOUBLE_COLORPICKER then
											for k3, v3 in pairs(v2[5][1]) do
												if menu:MouseInMenu(v3[3][1], v3[3][2], 28, 14) then
													v3[5] = true
													menu.colorPickerOpen = v3
													menu.colorPickerOpen = v3
													if v3[1][4] ~= nil then
														menu:SetColorPicker(
															true,
															v3[1],
															v3,
															true,
															v3[6],
															LOCAL_MOUSE.x,
															LOCAL_MOUSE.y + 36
														)
													else
														menu:SetColorPicker(
															true,
															v3[1],
															v3,
															false,
															v3[6],
															LOCAL_MOUSE.x,
															LOCAL_MOUSE.y + 36
														)
													end
												end
											end
										end
									end
								elseif v2[2] == SLIDER and not menu.dropbox_open then
									if menu:MouseInMenu(v2[7][1], v2[7][2], 22, 13) then
										local stepval = 1
										if v2.stepsize then
											stepval = v2.stepsize
										end
										if menu:modkeydown("shift", "left") then
											stepval = 0.1
										end
										if menu:MouseInMenu(v2[7][1], v2[7][2], 11, 13) then
											v2[1] -= stepval
										elseif menu:MouseInMenu(v2[7][1] + 11, v2[7][2], 11, 13) then
											v2[1] += stepval
										end

										if v2[1] < v2[6][1] then
											v2[1] = v2[6][1]
										elseif v2[1] > v2[6][2] then
											v2[1] = v2[6][2]
										end
										local decplaces = v2.decimal and string.rep("0", math.log(1 / v2.decimal) / math.log(10))
										if decplaces and math.abs(v2[1]) < v2.decimal then
											v2[1] = 0
										end
										v2[4][5].Text = v2.custom[v2[1]] or (v2[1] == math.floor(v2[1]) and v2.decimal) and tostring(v2[1]) .. "." .. decplaces .. v2[4][6] or tostring(v2[1]) .. v2[4][6]

										for i = 1, 4 do
											v2[4][i].Size = Vector2.new(
												(v2[3][3] - 4) * ((v2[1] - v2[6][1]) / (v2[6][2] - v2[6][1])),
												2
											)
										end
									elseif menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 28) then
										v2[5] = true
									end
								elseif v2[2] == DROPBOX then
									if menu.dropbox_open then
										if v2 ~= menu.dropbox_open then
											continue
										end
									end
									if menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 36) then
										if not v2[5] then
											v2[5] = menu:SetDropBox(
												true,
												v2[3][1] + menu.x + 1,
												v2[3][2] + menu.y + 13,
												v2[3][3],
												v2[1],
												v2[6]
											)
											newdropbox_open = v2
										else
											menu:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })
											v2[5] = false
											newdropbox_open = nil
										end
									elseif menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[6] + 1) + 3) and v2[5]
									then
										for i = 1, #v2[6] do
											if menu:MouseInMenu(
													v2[3][1],
													v2[3][2] + 36 + ((i - 1) * 21),
													v2[3][3],
													21
												)
											then
												v2[4][1].Text = v2[6][i]
												v2[1] = i
												menu:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })
												v2[5] = false
												newdropbox_open = nil
											end
										end

										if v2 == menu.options["Settings"]["Configuration"]["Configs"] then
											local textbox = menu.options["Settings"]["Configuration"]["ConfigName"]
											local relconfigs = GetConfigs()
											textbox[1] = relconfigs[menu.options["Settings"]["Configuration"]["Configs"][1]]
											textbox[4].Text = textbox[1]
										end
									end
								elseif v2[2] == COMBOBOX then
									if menu.dropbox_open then
										if v2 ~= menu.dropbox_open then
											continue
										end
									end
									if menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 36) then
										if not v2[5] then
											
											v2[5] = set_comboboxthingy(
												true,
												v2[3][1] + menu.x + 1,
												v2[3][2] + menu.y + 13,
												v2[3][3],
												v2[1],
												v2[6]
											)
											newdropbox_open = v2
										else
											menu:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })
											v2[5] = false
											newdropbox_open = nil
										end
									elseif menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[1] + 1) + 3) and v2[5]
									then
										for i = 1, #v2[1] do
											if menu:MouseInMenu(
													v2[3][1],
													v2[3][2] + 36 + ((i - 1) * 22),
													v2[3][3],
													23
												)
											then
												v2[1][i][2] = not v2[1][i][2]
												local textthing = ""
												for k, v in pairs(v2[1]) do
													if v[2] then
														if textthing == "" then
															textthing = v[1]
														else
															textthing = textthing .. ", " .. v[1]
														end
													end
												end
												textthing = textthing ~= "" and textthing or "None"
												if string.len(textthing) > 25 then
													textthing = string_cut(textthing, 25)
												end
												v2[4][1].Text = textthing
												set_comboboxthingy(
													true,
													v2[3][1] + menu.x + 1,
													v2[3][2] + menu.y + 13,
													v2[3][3],
													v2[1],
													v2[6]
												)
											end
										end
									end
								elseif v2[2] == BUTTON and not menu.dropbox_open then
									if menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 22) then
										if not v2[1] then
											buttonpressed(v2)
											if k2 == "Unload Cheat" then
												return
											end
											for i = 0, 8 do
												v2[4][i + 1].Color = ColorRange(i, {
													[1] = { start = 0, color = RGB(35, 35, 35) },
													[2] = { start = 8, color = RGB(50, 50, 50) },
												})
											end
											v2[1] = true
										end
									end
								elseif v2[2] == TEXTBOX and not menu.dropbox_open then
									if menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 22) then
										if not v2[5] then
											menu.textboxopen = v2

											v2[4].Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
											v2[5] = true
										end
									end
								elseif v2[2] == "list" then
									--[[
									menu.options[v.name][v1.name][v2.name] = {}
									menu.options[v.name][v1.name][v2.name][4] = Draw:List(v2.name, v1.x + 8, v1.y + y_pos, v1.width - 16, v2.size, v2.columns, tabz[k])
									menu.options[v.name][v1.name][v2.name][1] = nil
									menu.options[v.name][v1.name][v2.name][2] = v2.type
									menu.options[v.name][v1.name][v2.name][3] = 1
									menu.options[v.name][v1.name][v2.name][5] = {}
									menu.options[v.name][v1.name][v2.name][6] = v2.size
									menu.options[v.name][v1.name][v2.name][7] = v2.columns
									menu.options[v.name][v1.name][v2.name][8] = {v1.x + 8, v1.y + y_pos, v1.width - 16}
									]]
									--
									if #v2[5] > v2[6] then
										for i = 1, v2[6] do
											if menu:MouseInMenu(v2[8][1], v2[8][2] + (i * 22) - 5, v2[8][3], 22)
											then
												if v2[1] == tostring(v2[5][i + v2[3] - 1][1][1]) then
													v2[1] = nil
												else
													v2[1] = tostring(v2[5][i + v2[3] - 1][1][1])
												end
											end
										end
									else
										for i = 1, #v2[5] do
											if menu:MouseInMenu(v2[8][1], v2[8][2] + (i * 22) - 5, v2[8][3], 22)
											then
												if v2[1] == tostring(v2[5][i + v2[3] - 1][1][1]) then
													v2[1] = nil
												else
													v2[1] = tostring(v2[5][i + v2[3] - 1][1][1])
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
			menu.dropbox_open = newdropbox_open
		end
		for k, v in pairs(menu.options) do
			for k1, v1 in pairs(v) do
				for k2, v2 in pairs(v1) do
					if v2[2] == TOGGLE then
						if v2[6] then
							if not menu:GetVal("Settings", "Cheat Settings", "Allow Unsafe Features") then
								v2[1] = false
								for i = 0, 3 do
									v2[4][i + 1].Color = ColorRange(i, {
										[1] = { start = 0, color = RGB(50, 50, 50) },
										[2] = { start = 3, color = RGB(30, 30, 30) },
									})
								end
							end
						end
					end
				end
			end
		end
		menucolor()
	end

	

	local function mousebutton1upfunc()
		cp.dragging_m = false
		cp.dragging_r = false
		cp.dragging_b = false
		for k, v in pairs(menu.options) do
			if menu.tabnames[menu.activetab] == k then
				for k1, v1 in pairs(v) do
					for k2, v2 in pairs(v1) do
						if v2[2] == SLIDER and v2[5] then
							v2[5] = false
						end
						if v2[2] == BUTTON and v2[1] then
							for i = 0, 8 do
								v2[4][i + 1].Color = ColorRange(i, {
									[1] = { start = 0, color = RGB(50, 50, 50) },
									[2] = { start = 8, color = RGB(35, 35, 35) },
								})
							end
							v2[1] = false
						end
					end
				end
			end
		end
	end

	local clickspot_x, clickspot_y, original_menu_x, original_menu_y = 0, 0, 0, 0

	menu.connections.mwf = LOCAL_MOUSE.WheelForward:Connect(function()
		if menu.open then
			for k, v in pairs(menu.options) do
				if menu.tabnames[menu.activetab] == k then
					for k1, v1 in pairs(v) do
						for k2, v2 in pairs(v1) do
							if v2[2] == "list" then
								if v2[3] > 1 then
									v2[3] -= 1
								end
							end
						end
					end
				end
			end
		end
	end)

	menu.connections.mwb = LOCAL_MOUSE.WheelBackward:Connect(function()
		if menu.open then
			for k, v in pairs(menu.options) do
				if menu.tabnames[menu.activetab] == k then
					for k1, v1 in pairs(v) do
						for k2, v2 in pairs(v1) do
							if v2[2] == "list" then
								if v2[5][v2[3] + v2[6]] ~= nil then
									v2[3] += 1
								end
							end
						end
					end
				end
			end
		end
	end)

	function menu:setMenuAlpha(transparency)
		for k, v in pairs(bbmouse) do
			v.Transparency = transparency
		end
		for k, v in pairs(bbmenu) do
			v.Transparency = transparency
		end
		for k, v in pairs(tabz[menu.activetab]) do
			v.Transparency = transparency
		end
	end

	function menu:setMenuVisible(visible)
		for k, v in pairs(bbmouse) do
			v.Visible = visible
		end
		for k, v in pairs(bbmenu) do
			v.Visible = visible
		end
		for k, v in pairs(tabz[menu.activetab]) do
			v.Visible = visible
		end

		if visible then
			for k, v in pairs(menu.multigroups) do
				if menu.tabnames[menu.activetab] == k then
					for k1, v1 in pairs(v) do
						for k2, v2 in pairs(v1.vals) do
							for k3, v3 in pairs(menu.mgrouptabz[k][k2]) do
								v3.Visible = v2
							end
						end
					end
				end
			end
		end
	end

	menu:setMenuAlpha(0)
	menu:setMenuVisible(false)
	menu.lastActive = true
	menu.open = false
	menu.windowactive = true
	menu.connections.mousemoved = MouseMoved:connect(function(b)
		menu.windowactive = iswindowactive() or b
	end)

	local function renderSteppedMenu(fdt)
		if cp.dragging_m or cp.dragging_r or cp.dragging_b then
			menucolor()
		end
		menu.dt = fdt
		if menu.unloaded then
			return
		end
		SCREEN_SIZE = Camera.ViewportSize
		if bbmouse[#bbmouse-1] then
			if menu.inmenu and not menu.inmiddlemenu and not menu.intabs then
				bbmouse[#bbmouse-1].Visible = true
				bbmouse[#bbmouse-1].Transparency = 1
			else
				bbmouse[#bbmouse-1].Visible = false
			end
		end
		-- i pasted the old menu working ingame shit from the old source nate pls fix ty
		-- this is the really shitty alive check that we've been using since day one
		-- removed it :DDD
		-- im keepin all of our comments they're fun to look at
		-- i wish it showed comment dates that would be cool
		-- nah that would suck fk u (comment made on 3/4/2021 3:35 pm est by bitch)

		
		menu.lastActive = menu.windowactive
		for button, time in next, buttonsInQue do
			if time and tick() - time < doubleclickDelay then
				button[4].text.Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
				button[4].text.Text = "Confirm?"
			else
				button[4].text.Color = Color3.new(1, 1, 1)
				button[4].text.Text = button.name
			end
		end
		if menu.open then
			if menu.backspaceheld then
				local dt = tick() - menu.backspacetime
				if dt > 0.4 then
					menu.backspaceflags += 1
					if menu.backspaceflags % 5 == 0 then
						local textbox = menu.textboxopen
						textbox[1] = string.sub(textbox[1], 0, #textbox[1] - 1)
						textbox[4].Text = textbox[1] .. "|"
					end
				end
			end
		end
		if menu.fading then
			if menu.open then
				menu.timesincefade = tick() - menu.fadestart
				menu.fade_amount = 1 - (menu.timesincefade * 10)
				menu:SetPlusMinus(0, 20, 20)
				menu:setMenuAlpha(menu.fade_amount)
				if menu.fade_amount <= 0 then
					menu.open = false
					menu.fading = false
					menu:setMenuAlpha(0)
					menu:setMenuVisible(false)
				else
					menu:setMenuAlpha(menu.fade_amount)
				end
			else
				menu:setMenuVisible(true)
				setActiveTab(menu.activetab)
				menu.timesincefade = tick() - menu.fadestart
				menu.fade_amount = (menu.timesincefade * 10)
				menu.fadeamount = menu.fade_amount
				menu:setMenuAlpha(menu.fade_amount)
				if menu.fade_amount >= 1 then
					menu.open = true
					menu.fading = false
					menu:setMenuAlpha(1)
				else
					menu:setMenuAlpha(menu.fade_amount)
				end
			end
		end
		if menu.game == "uni" then
			if menu.open then
				INPUT_SERVICE.MouseBehavior = Enum.MouseBehavior.Default
			else
				if INPUT_SERVICE.MouseBehavior ~= menu.mousebehavior then
					INPUT_SERVICE.MouseBehavior = menu.mousebehavior
				end
			end
		end
		menu:SetMousePosition(LOCAL_MOUSE.x, LOCAL_MOUSE.y)
		local settooltip = true
		if menu.open or menu.fading then
			menu:SetPlusMinus(0, 20, 20)
			for k, v in pairs(menu.options) do
				if menu.tabnames[menu.activetab] == k then
					for k1, v1 in pairs(v) do
						local pass = true
						for k3, v3 in pairs(menu.multigroups) do
							if k == k3 then
								for k4, v4 in pairs(v3) do
									for k5, v5 in pairs(v4.vals) do
										if k1 == k5 then
											pass = v5
										end
									end
								end
							end
						end

						if pass then
							for k2, v2 in pairs(v1) do
								if v2[2] == TOGGLE then
									if not menu.dropbox_open and not menu.colorPickerOpen then
										if menu.open and menu:MouseInMenu(v2[3][1], v2[3][2], 30 + v2[4][5].TextBounds.x, 16)
										then
											if v2.tooltip and settooltip then
												menu:SetToolTip(
													menu.x + v2[3][1],
													menu.y + v2[3][2] + 18,
													v2.tooltip,
													true,
													fdt--[[this is really fucking stupid]] -- this is no longer really fucking stupid
												)
												settooltip = false
											end
										end
									end
								elseif v2[2] == SLIDER then
									if v2[5] then
										local new_val = (v2[6][2] - v2[6][1])  * (
												(
													LOCAL_MOUSE.x
													- menu.x
													- v2[3][1]
												) / v2[3][3]
											)
										v2[1] = (
												not v2.decimal and math.floor(new_val) or math.floor(new_val / v2.decimal) * v2.decimal
											) + v2[6][1]
										if v2[1] < v2[6][1] then
											v2[1] = v2[6][1]
										elseif v2[1] > v2[6][2] then
											v2[1] = v2[6][2]
										end
										local decplaces = v2.decimal and string.rep("0", math.log(1 / v2.decimal) / math.log(10))
										if decplaces and math.abs(v2[1]) < v2.decimal then
											v2[1] = 0
										end

										v2[4][5].Text = v2.custom[v2[1]] or (v2[1] == math.floor(v2[1]) and v2.decimal) and tostring(v2[1]) .. "." .. decplaces .. v2[4][6] or tostring(v2[1]) .. v2[4][6]
										for i = 1, 4 do
											v2[4][i].Size = Vector2.new(
												(v2[3][3] - 4) * ((v2[1] - v2[6][1]) / (v2[6][2] - v2[6][1])),
												2
											)
										end
										menu:SetPlusMinus(1, v2[7][1], v2[7][2])
									else
										if not menu.dropbox_open then
											if menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 28) then
												if menu:MouseInMenu(v2[7][1], v2[7][2], 22, 13) then
													if menu:MouseInMenu(v2[7][1], v2[7][2], 11, 13) then
														menu:SetPlusMinus(2, v2[7][1], v2[7][2])
													elseif menu:MouseInMenu(v2[7][1] + 11, v2[7][2], 11, 13) then
														menu:SetPlusMinus(3, v2[7][1], v2[7][2])
													end
												else
													menu:SetPlusMinus(1, v2[7][1], v2[7][2])
												end
											end
										end
									end
								elseif v2[2] == "list" then
									for k3, v3 in pairs(v2[4].liststuff) do
										for i, v4 in ipairs(v3) do
											for i1, v5 in ipairs(v4) do
												v5.Visible = false
											end
										end
									end
									for i = 1, v2[6] do
										if v2[5][i + v2[3] - 1] ~= nil then
											for i1 = 1, v2[7] do
												v2[4].liststuff.words[i][i1].Text = v2[5][i + v2[3] - 1][i1][1]
												v2[4].liststuff.words[i][i1].Visible = true

												if v2[5][i + v2[3] - 1][i1][1] == v2[1] and i1 == 1 then
													if menu.options["Settings"]["Cheat Settings"]["Menu Accent"][1]
													then
														local clr = menu.options["Settings"]["Cheat Settings"]["Menu Accent"][5][1]
														v2[4].liststuff.words[i][i1].Color = RGB(clr[1], clr[2], clr[3])
													else
														v2[4].liststuff.words[i][i1].Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
													end
												else
													v2[4].liststuff.words[i][i1].Color = v2[5][i + v2[3] - 1][i1][2]
												end
											end
											for k3, v3 in pairs(v2[4].liststuff.rows[i]) do
												v3.Visible = true
											end
										elseif v2[3] > 1 then
											v2[3] -= 1
										end
									end
									if v2[3] == 1 then
										for k3, v3 in pairs(v2[4].uparrow) do
											if v3.Visible then
												v3.Visible = false
											end
										end
									else
										for k3, v3 in pairs(v2[4].uparrow) do
											if not v3.Visible then
												v3.Visible = true
												menu:SetMenuPos(menu.x, menu.y)
											end
										end
									end
									if v2[5][v2[3] + v2[6]] == nil then
										for k3, v3 in pairs(v2[4].downarrow) do
											if v3.Visible then
												v3.Visible = false
											end
										end
									else
										for k3, v3 in pairs(v2[4].downarrow) do
											if not v3.Visible then
												v3.Visible = true
												menu:SetMenuPos(menu.x, menu.y)
											end
										end
									end
								end
							end
						end
					end
				end
			end
			menu.inmenu = LOCAL_MOUSE.x > menu.x and LOCAL_MOUSE.x < menu.x + menu.w and LOCAL_MOUSE.y > menu.y - 32 and LOCAL_MOUSE.y < menu.y + menu.h - 34
			menu.intabs = LOCAL_MOUSE.x > menu.x + 9 and LOCAL_MOUSE.x < menu.x + menu.w - 9 and LOCAL_MOUSE.y > menu.y - 9 and LOCAL_MOUSE.y < menu.y + 24
			menu.inmiddlemenu = LOCAL_MOUSE.x > menu.x + 18 and LOCAL_MOUSE.x < menu.x + menu.w - 18 and LOCAL_MOUSE.y > menu.y + 33 and LOCAL_MOUSE.y < menu.y + menu.h - 56
			if (
					--[[(
						LOCAL_MOUSE.x > menu.x and LOCAL_MOUSE.x < menu.x + menu.w and LOCAL_MOUSE.y > menu.y - 32 and LOCAL_MOUSE.y < menu.y - 11
					)]]
					(
						menu.inmenu and 
						not menu.intabs and
						not menu.inmiddlemenu
					) or menu.dragging
				) and not menu.dontdrag
			then
				if menu.mousedown and not menu.colorPickerOpen and not dropbox_open then
					if not menu.dragging then
						clickspot_x = LOCAL_MOUSE.x
						clickspot_y = LOCAL_MOUSE.y - 36 original_menu_X = menu.x original_menu_y = menu.y
						menu.dragging = true
					end
					menu.x = (original_menu_X - clickspot_x) + LOCAL_MOUSE.x
					menu.y = (original_menu_y - clickspot_y) + LOCAL_MOUSE.y - 36
					if menu.y < 0 then
						menu.y = 0
					end
					if menu.x < -menu.w / 4 * 3 then
						menu.x = -menu.w / 4 * 3
					end
					if menu.x + menu.w / 4 > SCREEN_SIZE.x then
						menu.x = SCREEN_SIZE.x - menu.w / 4
					end
					if menu.y > SCREEN_SIZE.y - 20 then
						menu.y = SCREEN_SIZE.y - 20
					end
					menu:SetMenuPos(menu.x, menu.y)
				else
					menu.dragging = false
				end
			elseif menu.mousedown then
				menu.dontdrag = true
			elseif not menu.mousedown then
				menu.dontdrag = false
			end
			if menu.colorPickerOpen then
				if cp.dragging_m then
					menu:SetDragBarM(
						clamp(LOCAL_MOUSE.x, cp.x + 12, cp.x + 167) - 2,
						clamp(LOCAL_MOUSE.y + 36, cp.y + 25, cp.y + 180) - 2
					)

					cp.hsv.s = (clamp(LOCAL_MOUSE.x, cp.x + 12, cp.x + 167) - cp.x - 12) / 155
					cp.hsv.v = 1 - ((clamp(LOCAL_MOUSE.y + 36, cp.y + 23, cp.y + 178) - cp.y - 23) / 155)
					newcolor.Color = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
					local tempclr = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
					menu.colorPickerOpen[4][1].Color = tempclr
					for i = 2, 3 do
						menu.colorPickerOpen[4][i].Color = RGB(
							math.floor(tempclr.R * 255) - 40,
							math.floor(tempclr.G * 255) - 40,
							math.floor(tempclr.B * 255) - 40
						)
					end
					if cp.alpha then
						menu.colorPickerOpen[1] = {
							math.floor(tempclr.R * 255),
							math.floor(tempclr.G * 255),
							math.floor(tempclr.B * 255),
							cp.hsv.a,
						}
					else
						menu.colorPickerOpen[1] = {
							math.floor(tempclr.R * 255),
							math.floor(tempclr.G * 255),
							math.floor(tempclr.B * 255),
						}
					end
				elseif cp.dragging_r then
					menu:SetDragBarR(cp.x + 175, clamp(LOCAL_MOUSE.y + 36, cp.y + 23, cp.y + 178))

					maincolor.Color = Color3.fromHSV(
							1 - ((clamp(LOCAL_MOUSE.y + 36, cp.y + 23, cp.y + 178) - cp.y - 23) / 155),
							1,
							1
						)

					cp.hsv.h = 1 - ((clamp(LOCAL_MOUSE.y + 36, cp.y + 23, cp.y + 178) - cp.y - 23) / 155)
					newcolor.Color = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
					local tempclr = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
					menu.colorPickerOpen[4][1].Color = tempclr
					for i = 2, 3 do
						menu.colorPickerOpen[4][i].Color = RGB(
							math.floor(tempclr.R * 255) - 40,
							math.floor(tempclr.G * 255) - 40,
							math.floor(tempclr.B * 255) - 40
						)
					end
					if cp.alpha then
						menu.colorPickerOpen[1] = {
							math.floor(tempclr.R * 255),
							math.floor(tempclr.G * 255),
							math.floor(tempclr.B * 255),
							cp.hsv.a,
						}
					else
						menu.colorPickerOpen[1] = {
							math.floor(tempclr.R * 255),
							math.floor(tempclr.G * 255),
							math.floor(tempclr.B * 255),
						}
					end
				elseif cp.dragging_b then
					local tempclr = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
					menu.colorPickerOpen[4][1].Color = tempclr
					for i = 2, 3 do
						menu.colorPickerOpen[4][i].Color = RGB(
							math.floor(tempclr.R * 255) - 40,
							math.floor(tempclr.G * 255) - 40,
							math.floor(tempclr.B * 255) - 40
						)
					end
					if cp.alpha then
						menu.colorPickerOpen[1] = {
							math.floor(tempclr.R * 255),
							math.floor(tempclr.G * 255),
							math.floor(tempclr.B * 255),
							cp.hsv.a,
						}
					else
						menu.colorPickerOpen[1] = {
							math.floor(tempclr.R * 255),
							math.floor(tempclr.G * 255),
							math.floor(tempclr.B * 255),
						}
					end
					menu:SetDragBarB(clamp(LOCAL_MOUSE.x, cp.x + 10, cp.x + 168), cp.y + 188)
					newcolor.Transparency = (clamp(LOCAL_MOUSE.x, cp.x + 10, cp.x + 168) - cp.x - 10) / 158
					cp.hsv.a = math.floor(((clamp(LOCAL_MOUSE.x, cp.x + 10, cp.x + 168) - cp.x - 10) / 158) * 255)
				else
					local setvisnew = menu:MouseInColorPicker(197, 37, 75, 40)
					for i, v in ipairs(newcopy) do
						v.Visible = setvisnew
					end

					local setvisold = menu:MouseInColorPicker(197, 91, 75, 40)
					for i, v in ipairs(oldcopy) do
						v.Visible = setvisold
					end
				end
			end
		else
			menu.dragging = false
		end
		if settooltip then
			menu:SetToolTip(nil, nil, nil, false, fdt)
		end
	end

	menu.connections.inputstart = INPUT_SERVICE.InputBegan:Connect(function(input)
		if menu then
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				menu.mousedown = true
				if menu.open and not menu.fading then
					MouseButton1Event()
				end
			elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
				if menu.open and not menu.fading then
					MouseButton2Event()
				end
			end

			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode.Name:match("Shift") then
					local kcn = input.KeyCode.Name
					local direction = kcn:split("Shift")[1]
					menu.modkeys.shift.direction = direction:lower()
				end
				if input.KeyCode.Name:match("Alt") then
					local kcn = input.KeyCode.Name
					local direction = kcn:split("Alt")[1]
					menu.modkeys.alt.direction = direction:lower()
				end
			end
			if not menu then
				return
			end -- this fixed shit with unload
			menu:InputBeganMenu(input)
			menu:InputBeganKeybinds(input)
			if menu.open then
				if menu.tabnames[menu.activetab] == "Settings" then
					local menutext = menu:GetVal("Settings", "Cheat Settings", "Custom Menu Name") and menu:GetVal("Settings", "Cheat Settings", "MenuName") or "Bitch Bot"

					bbmenu[27].Text = menutext

					menu.watermark.text[1].Text = menutext.. menu.watermark.textString

					for i, v in ipairs(menu.watermark.rect) do
						local len = #menu.watermark.text[1].Text * 7 + 10
						if i == #menu.watermark.rect then
							len += 2
						end
						v.Size = Vector2.new(len, v.Size.y)
					end
				end
			end
			if input.KeyCode == Enum.KeyCode.F2 then
				menu.stat_menu = not menu.stat_menu

				for k, v in pairs(graphs) do
					if k ~= "other" then
						for k1, v1 in pairs(v) do
							if k1 ~= "pos" then
								for k2, v2 in pairs(v1) do
									v2.Visible = menu.stat_menu
								end
							end
						end
					end
				end

				for k, v in pairs(graphs.other) do
					v.Visible = menu.stat_menu
				end
			end
		end
	end)

	menu.connections.inputended = INPUT_SERVICE.InputEnded:Connect(function(input)
		menu:InputEndedKeybinds(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			menu.mousedown = false
			if menu.open and not menu.fading then
				mousebutton1upfunc()
			end
		end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode.Name:match("Shift") then
				menu.modkeys.shift.direction = nil
			end
			if input.KeyCode.Name:match("Alt") then
				menu.modkeys.alt.direction = nil
			end
		end
	end)

	menu.connections.renderstepped = game.RunService.RenderStepped:Connect(renderSteppedMenu) -- fucking asshole 🖕🖕🖕

	function menu:unload()
		getgenv().v2 = nil
		self.unloaded = true

		for k, conn in next, self.connections do
			if not getrawmetatable(conn) then
				conn()
			else
				conn:Disconnect()
			end
			self.connections[k] = nil
		end

		game:service("ContextActionService"):UnbindAction("BB Keycheck")
		if self.game == "pf" then
			game:service("ContextActionService"):UnbindAction("BB PF check")
		elseif self.game == "uni" then
			game:service("ContextActionService"):UnbindAction("BB UNI check")
		end

		local mt = getrawmetatable(game)

		setreadonly(mt, false)

		local oldmt = menu.oldmt

		if oldmt then
			for k, v in next, mt do
				if oldmt[k] then
					mt[k] = oldmt[k]
				end
			end
		else
			--TODO nate do this please
			-- remember to store any "game" metatable hooks PLEASE PLEASE because this will ensure it replaces the meta so that it UNLOADS properly
			-- rconsoleerr("fatal error: no old game meta found! (UNLOAD PROBABLY WON'T WORK AS EXPECTED)")
		end

		setreadonly(mt, true)

		if menu.game == "pf" or menu.pfunload then
			menu:pfunload()
		end

		Draw:UnRender()
		CreateNotification = nil
		allrender = nil
		menu = nil
		Draw = nil
		self.unloaded = true
	end
end

local avgfps = 100

-- I STOLE THE FPS COUNTER FROM https://devforum.roblox.com/t/get-client-fps-trough-a-script/282631/14 😿😿😿😢😭
-- fixed ur shitty fps counter
local StatMenuRendered = event.new("StatMenuRendered")
menu.connections.heartbeatmenu = game.RunService.Heartbeat:Connect(function() --ANCHOR MENU HEARTBEAT
	if menu.open then
		if menu.y < 0 then
			menu.y = 0
			menu:SetMenuPos(menu.x, 0)
		end
		if menu.x < -menu.w / 4 * 3 then
			menu.x = -menu.w / 4 * 3
			menu:SetMenuPos(-menu.w / 4 * 3, menu.y)
		end
		if menu.x + menu.w / 4 > SCREEN_SIZE.x then
			menu.x = SCREEN_SIZE.x - menu.w / 4
			menu:SetMenuPos(SCREEN_SIZE.x - menu.w / 4, menu.y)
		end
		if menu.y > SCREEN_SIZE.y - 20 then
			menu.y = SCREEN_SIZE.y - 20
			menu:SetMenuPos(menu.x, SCREEN_SIZE.y - 20)
		end
	end
	if menu.stat_menu == false then
		return
	end
	local fps = 1 / (menu.dt or 1)
	avgfps = (fps + avgfps * 49) / 50
	local CurrentFPS = math.floor(avgfps)

	if tick() > lasttick + 0.25 then
		table.remove(networkin.incoming, 1)
		table.insert(networkin.incoming, stats.DataReceiveKbps)

		table.remove(networkin.outgoing, 1)
		table.insert(networkin.outgoing, stats.DataSendKbps)

		--incoming
		local biggestnum = 80
		for i = 1, 21 do
			if math.ceil(networkin.incoming[i]) > biggestnum - 10 then
				biggestnum = (math.ceil(networkin.incoming[i] / 10) + 1) * 10
				--graphs.incoming.pos.x - 21, graphs.incoming.pos.y - 7,
			end
		end

		local numstr = tostring(biggestnum)
		graphs.incoming.sides[2].Text = numstr
		graphs.incoming.sides[2].Position = Vector2.new(graphs.incoming.pos.x - ((#numstr + 1) * 7), graphs.incoming.pos.y - 7)

		for i = 1, 20 do
			local line = graphs.incoming.graph[i]

			line.From = Vector2.new(
				((i - 1) * 11) + graphs.incoming.pos.x,
				graphs.incoming.pos.y + 80 - math.floor(networkin.incoming[i] / biggestnum * 80)
			)

			line.To = Vector2.new(
				(i * 11) + graphs.incoming.pos.x,
				graphs.incoming.pos.y + 80 - math.floor(networkin.incoming[i + 1] / biggestnum * 80)
			)
		end

		local avgbar_h = average(networkin.incoming)

		graphs.incoming.graph[21].From = Vector2.new(
			graphs.incoming.pos.x + 1,
			graphs.incoming.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80)
		)
		graphs.incoming.graph[21].To = Vector2.new(
			graphs.incoming.pos.x + 220,
			graphs.incoming.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80)
		)
		graphs.incoming.graph[21].Color = RGB(unpack(menu.mc)) -- this is fucking stupid
		graphs.incoming.graph[21].Thickness = 2

		graphs.incoming.graph[22].Position = Vector2.new(
			graphs.incoming.pos.x + 222,
			graphs.incoming.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80) - 8
		)
		graphs.incoming.graph[22].Text = "avg: " .. tostring(round(avgbar_h, 2))
		graphs.incoming.graph[22].Color = RGB(unpack(menu.mc)) -- this is fucking stupid

		graphs.incoming.sides[1].Text = "incoming kbps: " .. tostring(round(networkin.incoming[21], 2))

		-- outgoing
		local biggestnum = 10
		for i = 1, 21 do
			if math.ceil(networkin.outgoing[i]) > biggestnum - 5 then
				biggestnum = (math.ceil(networkin.outgoing[i] / 5) + 1) * 5
			end
		end

		local numstr = tostring(biggestnum)
		graphs.outgoing.sides[2].Text = numstr
		graphs.outgoing.sides[2].Position = Vector2.new(graphs.outgoing.pos.x - ((#numstr + 1) * 7), graphs.outgoing.pos.y - 7)

		for i = 1, 20 do
			local line = graphs.outgoing.graph[i]

			line.From = Vector2.new(
				((i - 1) * 11) + graphs.outgoing.pos.x,
				graphs.outgoing.pos.y + 80 - math.floor(networkin.outgoing[i] / biggestnum * 80)
			)

			line.To = Vector2.new(
				(i * 11) + graphs.outgoing.pos.x,
				graphs.outgoing.pos.y + 80 - math.floor(networkin.outgoing[i + 1] / biggestnum * 80)
			)
		end

		local avgbar_h = average(networkin.outgoing)

		graphs.outgoing.graph[21].From = Vector2.new(
			graphs.outgoing.pos.x + 1,
			graphs.outgoing.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80)
		)
		graphs.outgoing.graph[21].To = Vector2.new(
			graphs.outgoing.pos.x + 220,
			graphs.outgoing.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80)
		)
		graphs.outgoing.graph[21].Color = RGB(unpack(menu.mc)) -- this is fucking stupid
		graphs.outgoing.graph[21].Thickness = 2

		graphs.outgoing.graph[22].Position = Vector2.new(
			graphs.outgoing.pos.x + 222,
			graphs.outgoing.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80) - 8
		)
		graphs.outgoing.graph[22].Text = "avg: " .. tostring(round(avgbar_h, 2))
		graphs.outgoing.graph[22].Color = RGB(unpack(menu.mc)) -- this is fucking stupid

		graphs.outgoing.sides[1].Text = "outgoing kbps: " .. tostring(round(networkin.outgoing[21], 2))

		local drawnobjects = 0
		for k, v in pairs(allrender) do
			drawnobjects += #v
		end

		graphs.other[1].Text = string.format(
			"initiation time: %d ms\ndrawn objects: %d\ntick: %d\nfps: %d\nlatency: %d",
			menu.load_time,
			drawnobjects,
			tick(),
			CurrentFPS,
			math.ceil(GetLatency() * 1000)
		)
		lasttick = tick()
		StatMenuRendered:fire(graphs.other[1])
	end
end)

local function keycheck(actionName, inputState, inputObject)
	if actionName == "BB Keycheck" then
		if menu.open then
			if menu.textboxopen then
				if inputObject.KeyCode == Enum.KeyCode.Backspace then
					if menu.selectall then
						menu.textboxopen[1] = ""
						menu.textboxopen[4].Text = "|"
						menu.textboxopen[4].Color = RGB(unpack(menu.mc))
						menu.selectall = false
					end
					local on = inputState == Enum.UserInputState.Begin
					menu.backspaceheld = on
					menu.backspacetime = on and tick() or -1
					if not on then
						menu.backspaceflags = 0
					end
				end

				if inputObject.KeyCode ~= Enum.KeyCode.A and (not inputObject.KeyCode.Name:match("^Left") and not inputObject.KeyCode.Name:match("^Right")) and inputObject.KeyCode ~= Enum.KeyCode.Delete
				then
					if menu.selectall then
						menu.textboxopen[4].Color = RGB(unpack(menu.mc))
						menu.selectall = false
					end
				end

				if inputObject.KeyCode == Enum.KeyCode.A then
					if inputState == Enum.UserInputState.Begin and INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftControl)
					then
						menu.selectall = true
						local textbox = menu.textboxopen
						textbox[4].Color = RGB(menu.mc[3], menu.mc[2], menu.mc[1])
					end
				end

				return Enum.ContextActionResult.Sink
			end
		end

		return Enum.ContextActionResult.Pass
	end
end
game:service("ContextActionService"):BindAction("BB Keycheck", keycheck, false, Enum.UserInputType.Keyboard)

if menu.game == "uni" then --SECTION UNIVERSAL
	menu.activetab = 4

	menu.mousebehavior = Enum.MouseBehavior.Default

	local mt = getrawmetatable(game)

	local newindex = mt.__newindex
	--[[local index = mt.__index
	local namecall = mt.__namecall]]

	setreadonly(mt, false)

	mt.__newindex = newcclosure(function(t, p, v)
		if not checkcaller() then
			if t == INPUT_SERVICE then
				if p == "MouseBehavior" then
					menu.mousebehavior = v
					if menu.open then
						newindex(t, p, Enum.MouseBehavior.Default)
						return
					end
				end
			end
		end

		return newindex(t, p, v)
	end)

	menu.oldmt = {
		__newindex = newindex,
	}

	setreadonly(mt, true)

	local allesp = {
		headdotoutline = {},
		headdot = {},
		name = {},
		outerbox = {},
		box = {},
		innerbox = {},
		healthouter = {},
		healthinner = {},
		hptext = {},
		distance = {},
		team = {},
	}

	for i = 1, Players.MaxPlayers do
		Draw:Circle(false, 20, 20, 10, 3, 10, { 10, 10, 10, 215 }, allesp.headdotoutline)
		Draw:Circle(false, 20, 20, 10, 1, 10, { 255, 255, 255, 255 }, allesp.headdot)

		Draw:OutlinedRect(false, 20, 20, 20, 20, { 0, 0, 0, 220 }, allesp.outerbox)
		Draw:OutlinedRect(false, 20, 20, 20, 20, { 0, 0, 0, 220 }, allesp.innerbox)
		Draw:OutlinedRect(false, 20, 20, 20, 20, { 255, 255, 255, 255 }, allesp.box)

		Draw:FilledRect(false, 20, 20, 4, 20, { 10, 10, 10, 215 }, allesp.healthouter)
		Draw:FilledRect(false, 20, 20, 20, 20, { 255, 255, 255, 255 }, allesp.healthinner)

		Draw:OutlinedText("", 1, false, 20, 20, 13, false, { 255, 255, 255, 255 }, { 0, 0, 0 }, allesp.hptext)
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, { 255, 255, 255, 255 }, { 0, 0, 0 }, allesp.distance)
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, { 255, 255, 255, 255 }, { 0, 0, 0 }, allesp.name)
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, { 255, 255, 255, 255 }, { 0, 0, 0 }, allesp.team)
	end

	menu.crosshair = { outline = {}, inner = {} }
	for i, v in pairs(menu.crosshair) do
		for i = 1, 2 do
			Draw:FilledRect(false, 20, 20, 20, 20, { 10, 10, 10, 215 }, v)
		end
	end

	menu.fovcircle = {}
	Draw:Circle(false, 20, 20, 10, 3, 20, { 10, 10, 10, 215 }, menu.fovcircle)
	Draw:Circle(false, 20, 20, 10, 1, 20, { 255, 255, 255, 255 }, menu.fovcircle)

	menu.Initialize({
		{
			name = "Aimbot",
			content = {
				{
					name = "Aimbot",
					autopos = "left",
					autofill = true,
					content = {
						{
							type = TOGGLE,
							name = "Enabled",
							value = false,
							extra = {
								type = KEYBIND,
								key = Enum.KeyCode.J,
								toggletype = 4,
							},
						},
						{
							type = COMBOBOX,
							name = "Checks",
							values = { { "Alive", true }, { "Same Team", false }, { "Distance", false } },
						},
						{
							type = SLIDER,
							name = "Max Distance",
							value = 100,
							minvalue = 30,
							maxvalue = 500,
							stradd = "m",
						},
						{
							type = SLIDER,
							name = "Aimbot FOV",
							value = 0,
							minvalue = 0,
							maxvalue = 360,
							stradd = "°",
						},
						{
							type = DROPBOX,
							name = "FOV Calculation",
							value = 1,
							values = { "Static", "Actual FOV" },
						},
						{
							type = TOGGLE,
							name = "Visibility Check",
							value = false,
						},
						{
							type = TOGGLE,
							name = "Auto Shoot",
							value = false,
						},
						{
							type = TOGGLE,
							name = "Smoothing",
							value = false,
						},
						{
							type = SLIDER,
							name = "Smoothing Value",
							value = 0,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%",
						},
					},
				},
			},
		},
		{
			name = "Visuals",
			content = {
				{
					name = "Player ESP",
					autopos = "left",
					content = {
						{
							type = TOGGLE,
							name = "Name",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Name ESP",
								color = { 255, 255, 255, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Head Dot",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Head Dot",
								color = { 255, 255, 255, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Box",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Box ESP",
								color = { 255, 255, 255, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Health Bar",
							value = false,
							extra = {
								type = DOUBLE_COLORPICKER,
								name = { "Low Health", "Max Health" },
								color = { { 255, 0, 0 }, { 0, 255, 0 } },
							},
						},
						{
							type = TOGGLE,
							name = "Health Number",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Health Number ESP",
								color = { 255, 255, 255, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Team",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Team ESP",
								color = { 255, 255, 255, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Team Color Based",
							value = false,
						},
						{
							type = TOGGLE,
							name = "Distance",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Distance ESP",
								color = { 255, 255, 255, 255 },
							},
						},
					},
				},
				{
					name = "Misc",
					autopos = "left",
					autofill = true,
					content = {
						{
							type = TOGGLE,
							name = "Custom Crosshair",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Crosshair Color",
								color = { 255, 255, 255, 255 },
							},
						},

						{
							type = DROPBOX,
							name = "Crosshair Position",
							value = 1,
							values = { "Center Of Screen", "Mouse" },
						},
						{
							type = SLIDER,
							name = "Crosshair Size",
							value = 10,
							minvalue = 5,
							maxvalue = 15,
							stradd = "px",
						},
						{
							type = TOGGLE,
							name = "Draw Aimbot FOV",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Aimbot FOV Circle Color",
								color = { 255, 255, 255, 255 },
							},
						},
					},
				},
				{
					name = "ESP Settings",
					autopos = "right",
					content = {
						{
							type = DROPBOX,
							name = "ESP Sorting",
							value = 1,
							values = { "None", "Distance" },
						},
						{
							type = COMBOBOX,
							name = "Checks",
							values = { { "Alive", true }, { "Same Team", false }, { "Distance", false } },
						},
						{
							type = SLIDER,
							name = "Max Distance",
							value = 100,
							minvalue = 30,
							maxvalue = 500,
							stradd = "m",
						},
						{
							type = TOGGLE,
							name = "Highlight Aimbot Target",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Aimbot Target",
								color = { 255, 150, 0, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Highlight Friends",
							value = true,
							extra = {
								type = COLORPICKER,
								name = "Friended Players",
								color = { 0, 255, 255, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Highlight Priority",
							value = true,
							extra = {
								type = COLORPICKER,
								name = "Priority Players",
								color = { 255, 210, 0, 255 },
							},
						},
					},
				},
				{
					name = "Local Visuals",
					autopos = "right",
					autofill = true,
					content = {
						{
							type = TOGGLE,
							name = "Change FOV",
							value = false,
						},
						{
							type = SLIDER,
							name = "Camera FOV",
							value = 60,
							minvalue = 60,
							maxvalue = 120,
							stradd = "°",
						},
					},
				},
			},
		},
		{
			name = "Misc",
			content = {
				{
					name = "Movement",
					autopos = "left",
					autofill = true,
					content = {
						{
							type = TOGGLE,
							name = "Speed",
							value = false,
						},
						{
							type = SLIDER,
							name = "Speed Factor",
							value = 40,
							minvalue = 1,
							maxvalue = 200,
							stradd = " stud/s",
						},
						{
							type = DROPBOX,
							name = "Speed Method",
							value = 1,
							values = { "Velocity", "Walk Speed" },
						},
						-- {
						-- 	type = COMBOBOX,
						-- 	name = COMBOBOX,
						-- 	values = {{"Head", true}, {"Body", true}, {"Arms", false}, {"Legs", false}}
						-- },
						{
							type = TOGGLE,
							name = "Fly",
							value = false,
							extra = {
								type = KEYBIND,
								key = Enum.KeyCode.B,
							},
						},
						{
							type = DROPBOX,
							name = "Fly Method",
							value = 1,
							values = { "Fly", "Noclip" },
						},
						{
							type = SLIDER,
							name = "Fly Speed",
							value = 40,
							minvalue = 1,
							maxvalue = 200,
							stradd = " stud/s",
						},
						{
							type = TOGGLE,
							name = "Mouse Teleport",
							value = false,
							extra = {
								type = KEYBIND,
								key = Enum.KeyCode.Q,
								toggletype = 0
							},
						},
					},
				},
				{
					name = "Exploits",
					autopos = "right",
					autofill = true,
					content = {
						{
							type = TOGGLE,
							name = "Enable Tick Manipulation",
							value = false,
							unsafe = true,
						},
						{
							type = TOGGLE,
							name = "Shift Tick Base",
							value = false,
							extra = {
								type = KEYBIND,
								key = Enum.KeyCode.E,
							},
						},
						{
							type = SLIDER,
							name = "Shifted Tick Base Add",
							value = 20,
							minvalue = 1,
							maxvalue = 1000,
							stradd = "ms",
						},
					},
				},
			},
		},
		{
			name = "Settings",
			content = {
				{
					name = "Player List",
					x = menu.columns.left,
					y = 66,
					width = menuWidth - 34, -- this does nothing?
					height = 328,
					content = {
						{
							type = "list",
							name = "Players",
							multiname = { "Name", "Team", "Status" },
							size = 9,
							columns = 3,
						},
						{
							type = IMAGE,
							name = "Player Info",
							text = "No Player Selected",
							size = 72,
						},
						{
							type = DROPBOX,
							name = "Player Status",
							x = 307,
							y = 314,
							w = 160,
							value = 1,
							values = { "None", "Friend", "Priority" },
						},
					},
				},
				{
					name = "Cheat Settings",
					x = menu.columns.left,
					y = 400,
					width = menu.columns.width,
					height = 182,
					content = {
						{
							type = TOGGLE,
							name = "Menu Accent",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Accent Color",
								color = { 127, 72, 163 },
							},
						},
						{
							type = TOGGLE,
							name = "Watermark",
							value = true,
						},
						{
							type = TOGGLE,
							name = "Custom Menu Name",
							value = MenuName and true or false,
						},
						{
							type = TEXTBOX,
							name = "MenuName",
							text = MenuName or "Bitch Bot",
						},
						{
							type = BUTTON,
							name = "Set Clipboard Game ID",
						},
						{
							type = BUTTON,
							name = "Unload Cheat",
							doubleclick = true,
						},
						{
							type = TOGGLE,
							name = "Allow Unsafe Features",
							value = false,
						},
					},
				},
				{
					name = "Configuration",
					x = menu.columns.right,
					y = 400,
					width = menu.columns.width,
					height = 182,
					content = {
						{
							type = TEXTBOX,
							name = "ConfigName",
							file = true,
							text = "",
						},
						{
							type = DROPBOX,
							name = "Configs",
							value = 1,
							values = GetConfigs(),
						},
						{
							type = BUTTON,
							name = "Load Config",
							doubleclick = true,
						},
						{
							type = BUTTON,
							name = "Save Config",
							doubleclick = true,
						},
						{
							type = BUTTON,
							name = "Delete Config",
							doubleclick = true,
						},
					},
				},
			},
		},
	})

	local selectedPlayer = nil
	local plistinfo = menu.options["Settings"]["Player List"]["Player Info"][1]
	local plist = menu.options["Settings"]["Player List"]["Players"]
	local function updateplist()
		if menu == nil then
			return
		end
		local playerlistval = menu:GetVal("Settings", "Player List", "Players")
		local playerz = {}

		for i, team in pairs(TEAMS:GetTeams()) do
			local sorted_players = {}
			for i1, player in pairs(team:GetPlayers()) do
				table.insert(sorted_players, player.Name)
			end
			table.sort(sorted_players)
			for i1, player_name in pairs(sorted_players) do
				table.insert(playerz, Players:FindFirstChild(player_name))
			end
		end

		local sorted_players = {}
		for i, player in pairs(Players:GetPlayers()) do
			if player.Team == nil then
				table.insert(sorted_players, player.Name)
			end
		end
		table.sort(sorted_players)
		for i, player_name in pairs(sorted_players) do
			table.insert(playerz, Players:FindFirstChild(player_name))
		end
		sorted_players = nil

		local templist = {}
		for k, v in pairs(playerz) do
			local plyrname = { v.Name, RGB(255, 255, 255) }
			local teamtext = { "None", RGB(255, 255, 255) }
			local plyrstatus = { "None", RGB(255, 255, 255) }
			if v.Team ~= nil then
				teamtext[1] = v.Team.Name
				teamtext[2] = v.TeamColor.Color
			end
			if v == LOCAL_PLAYER then
				plyrstatus[1] = "Local Player"
				plyrstatus[2] = RGB(66, 135, 245)
			elseif table.find(menu.friends, v.Name) then
				plyrstatus[1] = "Friend"
				plyrstatus[2] = RGB(0, 255, 0)
			elseif table.find(menu.priority, v.Name) then
				plyrstatus[1] = "Priority"
				plyrstatus[2] = RGB(255, 210, 0)
			end

			table.insert(templist, { plyrname, teamtext, plyrstatus })
		end
		plist[5] = templist
		if playerlistval ~= nil then
			for i, v in ipairs(playerz) do
				if v.Name == playerlistval then
					selectedPlayer = v
					break
				end
				if i == #playerz then
					selectedPlayer = nil
					menu.list.setval(plist, nil)
				end
			end
		end
		menu:SetMenuPos(menu.x, menu.y)
	end

	local function setplistinfo(player, textonly)
		if not menu then
			return
		end
		if player ~= nil then
			local playerteam = "None"
			if player.Team ~= nil then
				playerteam = player.Team.Name
			end
			local playerhealth = "?"

			if player.Character ~= nil then
				local humanoid = player.Character:FindFirstChild("Humanoid")
				if humanoid ~= nil then
					if humanoid.Health ~= nil then
						playerhealth = tostring(humanoid.Health) .. "/" .. tostring(humanoid.MaxHealth)
					else
						playerhealth = "No health found"
					end
				else
					playerhealth = "Humanoid not found"
				end
			end

			plistinfo[1].Text = "Name: " .. player.Name .. "\nTeam: " .. playerteam .. "\nHealth: " .. playerhealth

			if textonly == nil then
				plistinfo[2].Data = BBOT_IMAGES[5]
				plistinfo[2].Data = game:HttpGet(string.format(
					"https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=100&height=100&format=png",
					player.UserId
				))
			end
		else
			plistinfo[2].Data = BBOT_IMAGES[5]
			plistinfo[1].Text = "No Player Selected"
		end
	end

	menu.list.removeall(menu.options["Settings"]["Player List"]["Players"])
	updateplist()
	setplistinfo(nil)

	local cachedValues = {
		FieldOfView = Camera.FieldOfView,
		FlyToggle = false,
	}

	function menu:SetVisualsColor()
		if menu.unloaded == true then
			return
		end
		for i = 1, Players.MaxPlayers do
			local hdt = menu:GetVal("Visuals", "Player ESP", "Head Dot", COLOR)[4]
			allesp.headdot[i].Color = menu:GetVal("Visuals", "Player ESP", "Head Dot", COLOR, true)
			allesp.headdot[i].Transparency = hdt / 255
			allesp.headdotoutline[i].Transparency = (hdt - 40) / 255

			local boxt = menu:GetVal("Visuals", "Player ESP", "Box", COLOR)[4]
			allesp.box[i].Color = menu:GetVal("Visuals", "Player ESP", "Box", COLOR, true)
			allesp.box[i].Transparency = boxt
			allesp.innerbox[i].Transparency = boxt
			allesp.outerbox[i].Transparency = boxt

			allesp.hptext[i].Color = menu:GetVal("Visuals", "Player ESP", "Health Number", COLOR, true)
			allesp.hptext[i].Transparency = menu:GetVal("Visuals", "Player ESP", "Health Number", COLOR)[4] / 255

			allesp.name[i].Color = menu:GetVal("Visuals", "Player ESP", "Name", COLOR, true)
			allesp.name[i].Transparency = menu:GetVal("Visuals", "Player ESP", "Name", COLOR)[4] / 255

			allesp.team[i].Color = menu:GetVal("Visuals", "Player ESP", "Team", COLOR, true)
			allesp.team[i].Transparency = menu:GetVal("Visuals", "Player ESP", "Team", COLOR)[4] / 255

			allesp.distance[i].Color = menu:GetVal("Visuals", "Player ESP", "Distance", COLOR, true)
			allesp.distance[i].Transparency = menu:GetVal("Visuals", "Player ESP", "Distance", COLOR)[4] / 255
		end
	end

	menu.tickbase_manip_added = false
	menu.tickbaseadd = 0

	local function SpeedHack()
		local speed = menu:GetVal("Misc", "Movement", "Speed Factor")

		if menu:GetVal("Misc", "Movement", "Speed") and LOCAL_PLAYER.Character and LOCAL_PLAYER.Character.Humanoid
		then
			if menu:GetVal("Misc", "Movement", "Speed Method") == 1 then
				local rootpart = LOCAL_PLAYER.Character:FindFirstChild("HumanoidRootPart")

				if rootpart ~= nil then
					local travel = Vector3.new()
					local looking = Workspace.CurrentCamera.CFrame.lookVector
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.W) then
						travel += Vector3.new(looking.x, 0, looking.Z)
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.S) then
						travel -= Vector3.new(looking.x, 0, looking.Z)
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.D) then
						travel += Vector3.new(-looking.Z, 0, looking.x)
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.A) then
						travel += Vector3.new(looking.Z, 0, -looking.x)
					end

					travel = travel.Unit

					local newDir = Vector3.new(travel.x * speed, rootpart.Velocity.y, travel.Z * speed)

					if travel.Unit.x == travel.Unit.x then
						rootpart.Velocity = newDir
					end
				end
			elseif LOCAL_PLAYER.Character.Humanoid then
				LOCAL_PLAYER.Character.Humanoid.WalkSpeed = speed
			end
		end
	end

	local function FlyHack()
		if menu:GetVal("Misc", "Movement", "Fly") then
			local rootpart = LOCAL_PLAYER.Character:FindFirstChild("HumanoidRootPart")

			if menu:GetVal("Misc", "Movement", "Fly Method") == 2 then
				for lI, lV in pairs(LOCAL_PLAYER.Character:GetDescendants()) do
					if lV:IsA("BasePart") then
						lV.CanCollide = false
					end
				end
			end

			if cachedValues.FlyToggle then
				local speed = menu:GetVal("Misc", "Movement", "Fly Speed")

				local travel = Vector3.new()
				local looking = workspace.CurrentCamera.CFrame.lookVector --getting camera looking vector

				do
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.W) then
						travel += looking
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.S) then
						travel -= looking
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.D) then
						travel += Vector3.new(-looking.Z, 0, looking.x)
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.A) then
						travel += Vector3.new(looking.Z, 0, -looking.x)
					end

					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.Space) then
						travel += Vector3.new(0, 1, 0)
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftShift) then
						travel -= Vector3.new(0, 1, 0)
					end
				end

				if travel.Unit.x == travel.Unit.x then
					rootpart.Anchored = false
					rootpart.Velocity = travel.Unit * speed --multiply the unit by the speed to make
				else
					rootpart.Velocity = Vector3.new(0, 0, 0)
					rootpart.Anchored = true
				end
			elseif cachedValues.FlyToggle then
				rootpart.Anchored = false
				cachedValues.FlyToggle = false
			end
		end
	end

	local function Aimbot()
		if menu:GetVal("Aimbot", "Aimbot", "Enabled") and INPUT_SERVICE:IsKeyDown(menu:GetVal("Aimbot", "Aimbot", "Enabled", KEYBIND))
		then
			local organizedPlayers = {}
			local fovType = menu:GetVal("Aimbot", "Aimbot", "FOV Calculation")
			local fov = menu:GetVal("Aimbot", "Aimbot", "Aimbot FOV")
			local mousePos = Vector3.new(LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36, 0)
			for i, v in ipairs(Players:GetPlayers()) do
				if v == LOCAL_PLAYER then
					continue
				end

				if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") then
					local checks = menu:GetVal("Aimbot", "Aimbot", "Checks")
					local humanoid = v.Character:FindFirstChild("Humanoid")
					if humanoid then
						if checks[1] and humanoid.Health <= 0 then
							continue
						end
					end
					local pos = Camera:WorldToViewportPoint(v.Character.Head.Position)
					if fovType == 1 and (pos - mousePos).Magnitude > fov and fov ~= 0 then
						continue
					end
					if checks[2] and v.Team and v.Team == LOCAL_PLAYER.Team then
						continue
					end
					if checks[3] and LOCAL_PLAYER:DistanceFromCharacter(v.Character.HumanoidRootPart.Position) / 5 > menu:GetVal("Aimbot", "Aimbot", "Max Distance")
					then
						continue
					end

					table.insert(organizedPlayers, v)
				end
			end

			table.sort(organizedPlayers, function(a, b)
				local aPos, aVis = workspace.CurrentCamera:WorldToViewportPoint(a.Character.Head.Position)
				local bPos, bVis = workspace.CurrentCamera:WorldToViewportPoint(b.Character.Head.Position)
				if aVis and not bVis then
					return true
				end
				if bVis and not aVis then
					return false
				end
				return (aPos - mousePos).Magnitude < (bPos - mousePos).Magnitude
			end)

			for i, v in ipairs(organizedPlayers) do
				local humanoid = v.Character:FindFirstChild("Humanoid")
				local rootpart = v.Character.HumanoidRootPart.Position
				local head = v.Character:FindFirstChild("Head")

				if head then
					local pos, onscreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)

					if onscreen then
						if INPUT_SERVICE.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
							mousemoveabs(pos.x, pos.y) --TODO NATE FIX THIS AIMBOT MAKE IT HEAT AND MAKE IT SORT BY FOV
						else
							Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
						end
						return
					end
				end
			end
		end
	end

	local oldslectedplyr = nil
	menu.connections.inputstart2 = INPUT_SERVICE.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if menu.open then
				if menu.tickbase_manip_added == false and menu:GetVal("Misc", "Exploits", "Enable Tick Manipulation")
				then
					shared.tick_ref = hookfunc(tick, function()
						if checkcaller() then
							return shared.tick_ref()
						end
						if not menu then
							return shared.tick_ref()
						elseif menu:GetVal("Misc", "Exploits", "Enable Tick Manipulation") and menu:GetVal("Misc", "Exploits", "Shift Tick Base") and INPUT_SERVICE:IsKeyDown(menu:GetVal("Misc", "Exploits", "Shift Tick Base", KEYBIND))
						then
							menu.tickbaseadd += menu:GetVal("Misc", "Exploits", "Shifted Tick Base Add") * 0.001
							return shared.tick_ref() + menu.tickbaseadd
						else
							return shared.tick_ref()
						end
					end)
					menu.tickbase_manip_added = true
				end

				if menu.tabnames[menu.activetab] == "Settings" and menu.open then
					game.RunService.Stepped:wait()

					updateplist()

					if selectedPlayer ~= nil then
						if menu:MouseInMenu(28, 68, 448, 238) then
							if table.find(menu.friends, selectedPlayer.Name) then
								menu.options["Settings"]["Player List"]["Player Status"][1] = 2
								menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "Friend"
							elseif table.find(menu.priority, selectedPlayer.Name) then
								menu.options["Settings"]["Player List"]["Player Status"][1] = 3
								menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "Priority"
							else
								menu.options["Settings"]["Player List"]["Player Status"][1] = 1
								menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "None"
							end
						end

						for k, table_ in pairs({ menu.friends, menu.priority }) do
							for index, plyrname in pairs(table_) do
								if selectedPlayer.Name == plyrname then
									table.remove(table_, index)
								end
							end
						end
						if menu:GetVal("Settings", "Player List", "Player Status") == 2 then
							if not table.find(menu.friends, selectedPlayer.Name) then
								table.insert(menu.friends, selectedPlayer.Name)
								WriteRelations()
							end
						elseif menu:GetVal("Settings", "Player List", "Player Status") == 3 then
							if not table.find(menu.priority, selectedPlayer.Name) then
								table.insert(menu.priority, selectedPlayer.Name)
								WriteRelations()
							end
						end
					else
						menu.options["Settings"]["Player List"]["Player Status"][1] = 1
						menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "None"
					end

					updateplist()

					if plist[1] ~= nil then
						if oldslectedplyr ~= selectedPlayer then
							setplistinfo(selectedPlayer)
							oldslectedplyr = selectedPlayer
						end
					else
						setplistinfo(nil)
					end
				end

				game.RunService.Stepped:wait()
				if not menu then
					return
				end
				local crosshairvis = menu:GetVal("Visuals", "Misc", "Custom Crosshair")
				for k, v in pairs(menu.crosshair) do
					v[1].Visible = crosshairvis
					v[2].Visible = crosshairvis
				end
				if menu:GetVal("Visuals", "Misc", "Draw Aimbot FOV") and menu:GetVal("Aimbot", "Aimbot", "Enabled")
				then
					menu.fovcircle[1].Visible = true
					menu.fovcircle[2].Visible = true

					menu.fovcircle[2].Color = menu:GetVal("Visuals", "Misc", "Draw Aimbot FOV", COLOR, true)
					local transparency = menu:GetVal("Visuals", "Misc", "Draw Aimbot FOV", COLOR)[4]
					menu.fovcircle[1].Transparency = (transparency - 40) / 255
					menu.fovcircle[2].Transparency = transparency / 255
				else
					menu.fovcircle[1].Visible = false
					menu.fovcircle[2].Visible = false
				end
				if menu:GetVal("Visuals", "Misc", "Custom Crosshair") then
					local size = menu:GetVal("Visuals", "Misc", "Crosshair Size")
					local color = menu:GetVal("Visuals", "Misc", "Custom Crosshair", COLOR, true)
					menu.crosshair.inner[1].Size = Vector2.new(size * 2 + 1, 1)
					menu.crosshair.inner[2].Size = Vector2.new(1, size * 2 + 1)

					menu.crosshair.inner[1].Color = color
					menu.crosshair.inner[2].Color = color

					menu.crosshair.outline[1].Size = Vector2.new(size * 2 + 3, 3)
					menu.crosshair.outline[2].Size = Vector2.new(3, size * 2 + 3)
				end
				menu:SetVisualsColor()
			end
		end
	end)

	-- local function Aimbot()
	-- 	if -- end

	local function unikeycheck(actionName, inputState, inputObject)
		if actionName == "BB UNI check" then
			if inputState == Enum.UserInputState.Begin then
				if menu:GetVal("Misc", "Movement", "Fly") and inputObject.KeyCode == menu:GetVal("Misc", "Movement", "Fly", KEYBIND)
				then
					cachedValues.FlyToggle = not cachedValues.FlyToggle
					LOCAL_PLAYER.Character.HumanoidRootPart.Anchored = false
					return Enum.ContextActionResult.Sink
				end
				if menu:GetVal("Misc", "Movement", "Mouse Teleport") and inputObject.KeyCode == menu:GetVal("Misc", "Movement", "Mouse Teleport", KEYBIND)
				then
					local targetPos = LOCAL_MOUSE.Hit.p
					local RP = LOCAL_PLAYER.Character.HumanoidRootPart
					RP.CFrame = CFrame.new(targetPos + Vector3.new(0, 7, 0))
					return Enum.ContextActionResult.Sink
				end
			end

			-----------------------------------------
			------------"HELD KEY ACTION"------------
			-----------------------------------------
			local keyflag = inputState == Enum.UserInputState.Begin

			if inputObject.KeyCode == menu:GetVal("Misc", "Exploits", "Shift Tick Base", KEYBIND) then
				menu.tickbaseadd = 0
				return Enum.ContextActionResult.Sink
			end

			return Enum.ContextActionResult.Pass -- this will let any other keyboard action proceed
		end
	end
	game:service("ContextActionService"):BindAction("BB UNI check", unikeycheck, false, Enum.UserInputType.Keyboard)

	menu.connections.renderstepped2 = game.RunService.RenderStepped:Connect(function()
		pcall(SpeedHack) -- ?????
		pcall(FlyHack)
		pcall(Aimbot)

		if menu.open then
			if menu.tabnames[menu.activetab] == "Settings" then
				if plist[1] ~= nil then
					setplistinfo(selectedPlayer, true)
				end
			end
		end

		if menu:GetVal("Visuals", "Misc", "Custom Crosshair") then
			local size = menu:GetVal("Visuals", "Misc", "Crosshair Size")
			if menu:GetVal("Visuals", "Misc", "Crosshair Position") == 1 then
				menu.crosshair.inner[1].Position = Vector2.new(SCREEN_SIZE.x / 2 - size, SCREEN_SIZE.y / 2)
				menu.crosshair.inner[2].Position = Vector2.new(SCREEN_SIZE.x / 2, SCREEN_SIZE.y / 2 - size)

				menu.crosshair.outline[1].Position = Vector2.new(SCREEN_SIZE.x / 2 - size - 1, SCREEN_SIZE.y / 2 - 1)
				menu.crosshair.outline[2].Position = Vector2.new(SCREEN_SIZE.x / 2 - 1, SCREEN_SIZE.y / 2 - 1 - size)
			else
				-- INPUT_SERVICE.MouseIconEnabled = false
				menu.crosshair.inner[1].Position = Vector2.new(LOCAL_MOUSE.x - size, LOCAL_MOUSE.y + 36)
				menu.crosshair.inner[2].Position = Vector2.new(LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36 - size)

				menu.crosshair.outline[1].Position = Vector2.new(LOCAL_MOUSE.x - size - 1, LOCAL_MOUSE.y + 35)
				menu.crosshair.outline[2].Position = Vector2.new(LOCAL_MOUSE.x - 1, LOCAL_MOUSE.y + 35 - size)
			end
		end

		if menu:GetVal("Visuals", "Local Visuals", "Change FOV") then
			Camera.FieldOfView = menu:GetVal("Visuals", "Local Visuals", "Camera FOV")
		end

		if menu:GetVal("Visuals", "Misc", "Draw Aimbot FOV") and menu:GetVal("Aimbot", "Aimbot", "Enabled") then
			menu.fovcircle[1].Position = Vector2.new(LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36)
			menu.fovcircle[2].Position = Vector2.new(LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36)

			local aimfov = menu:GetVal("Aimbot", "Aimbot", "Aimbot FOV")
			if menu:GetVal("Aimbot", "Aimbot", "FOV Calculation") == 2 then
				menu.fovcircle[1].Radius = aimfov / Camera.FieldOfView * Camera.ViewportSize.y
				menu.fovcircle[2].Radius = aimfov / Camera.FieldOfView * Camera.ViewportSize.y
			elseif menu.open then
				menu.fovcircle[1].Radius = aimfov
				menu.fovcircle[2].Radius = aimfov
			end
		end

		CreateThread(function()
			for k, v in pairs(allesp) do
				for k1, v1 in ipairs(v) do
					if v1.Visible then
						v1.Visible = false
					end
				end
			end

			local organizedPlayers = {}
			for i, v in ipairs(Players:GetPlayers()) do
				if v == LOCAL_PLAYER then
					continue
				end

				if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") then
					local checks = menu:GetVal("Visuals", "ESP Settings", "Checks")
					local humanoid = v.Character:FindFirstChild("Humanoid")
					if humanoid then
						if checks[1] and humanoid.Health <= 0 then
							continue
						end
					end
					if v.Team ~= nil then
						if checks[2] and v.Team == LOCAL_PLAYER.Team then
							continue
						end
					end
					if checks[3] and LOCAL_PLAYER:DistanceFromCharacter(v.Character.HumanoidRootPart.Position) / 5 > menu:GetVal("Visuals", "ESP Settings", "Max Distance")
					then
						continue
					end

					table.insert(organizedPlayers, v)
				end
			end

			if menu:GetVal("Visuals", "ESP Settings", "ESP Sorting") == 2 then
				table.sort(organizedPlayers, function(a, b)
					return LOCAL_PLAYER:DistanceFromCharacter(a.Character.HumanoidRootPart.Position) > LOCAL_PLAYER:DistanceFromCharacter(b.Character.HumanoidRootPart.Position)
				end)
			end

			for i, v in ipairs(organizedPlayers) do
				local humanoid = v.Character:FindFirstChild("Humanoid")
				local rootpart = v.Character.HumanoidRootPart.Position

				local cam = Camera.CFrame
				local torso = v.Character.PrimaryPart.CFrame
				local head = v.Character.Head.CFrame
				-- local vTop = torso.Position + (torso.UpVector * 1.8) + cam.UpVector
				-- local vBottom = torso.Position - (torso.UpVector * 2.5) - cam.UpVector
				local top, top_isrendered = workspace.CurrentCamera:WorldToViewportPoint(head.Position + (torso.UpVector * 1.3) + cam.UpVector)
				local bottom, bottom_isrendered = workspace.CurrentCamera:WorldToViewportPoint(torso.Position - (torso.UpVector * 3) - cam.UpVector)

				local minY = math.abs(bottom.y - top.y)
				local sizeX = math.ceil(math.max(clamp(math.abs(bottom.x - top.x) * 2, 0, minY), minY / 2))
				local sizeY = math.ceil(math.max(minY, sizeX * 0.5))

				if top_isrendered or bottom_isrendered then
					local boxtop = Vector2.new(
						math.floor(top.x * 0.5 + bottom.x * 0.5 - sizeX * 0.5),
						math.floor(math.min(top.y, bottom.y))
					)
					local boxsize = { w = sizeX, h = sizeY }

					if menu:GetVal("Visuals", "Player ESP", "Head Dot") then
						local head = v.Character:FindFirstChild("Head")
						if head then
							local headpos = head.Position
							local headdotpos = workspace.CurrentCamera:WorldToViewportPoint(Vector3.new(headpos.x, headpos.y, headpos.z))
							local headdotpos_b = workspace.CurrentCamera:WorldToViewportPoint(Vector3.new(headpos.x, headpos.y - 0.3, headpos.z))
							local difference = headdotpos_b.y - headdotpos.y
							allesp.headdot[i].Visible = true
							allesp.headdot[i].Position = Vector2.new(headdotpos.x, headdotpos.y - difference)
							allesp.headdot[i].Radius = difference * 2

							allesp.headdotoutline[i].Visible = true
							allesp.headdotoutline[i].Position = Vector2.new(headdotpos.x, headdotpos.y - difference)
							allesp.headdotoutline[i].Radius = difference * 2
						end
					end
					if menu:GetVal("Visuals", "Player ESP", "Box") then
						allesp.outerbox[i].Position = Vector2.new(boxtop.x - 1, boxtop.y - 1)
						allesp.outerbox[i].Size = Vector2.new(boxsize.w + 2, boxsize.h + 2)
						allesp.outerbox[i].Visible = true

						allesp.innerbox[i].Position = Vector2.new(boxtop.x + 1, boxtop.y + 1)
						allesp.innerbox[i].Size = Vector2.new(boxsize.w - 2, boxsize.h - 2)
						allesp.innerbox[i].Visible = true

						allesp.box[i].Position = Vector2.new(boxtop.x, boxtop.y)
						allesp.box[i].Size = Vector2.new(boxsize.w, boxsize.h)
						allesp.box[i].Visible = true
					end
					if humanoid then
						local health = math.ceil(humanoid.Health)
						local maxhealth = humanoid.MaxHealth
						if menu:GetVal("Visuals", "Player ESP", "Health Bar") then
							allesp.healthouter[i].Position = Vector2.new(boxtop.x - 6, boxtop.y - 1)
							allesp.healthouter[i].Size = Vector2.new(4, boxsize.h + 2)
							allesp.healthouter[i].Visible = true

							local ySizeBar = -math.floor(boxsize.h * health / maxhealth)

							allesp.healthinner[i].Position = Vector2.new(boxtop.x - 5, boxtop.y + boxsize.h)
							allesp.healthinner[i].Size = Vector2.new(2, ySizeBar)
							allesp.healthinner[i].Visible = true
							allesp.healthinner[i].Color = ColorRange(health, {
								[1] = {
									start = 0,
									color = menu:GetVal("Visuals", "Player ESP", "Health Bar", COLOR1, true),
								},
								[2] = {
									start = 100,
									color = menu:GetVal("Visuals", "Player ESP", "Health Bar", COLOR2, true),
								},
							})

							if menu:GetVal("Visuals", "Player ESP", "Health Number") then
								allesp.hptext[i].Text = tostring(health)
								local textsize = allesp.hptext[i].TextBounds
								allesp.hptext[i].Position = Vector2.new(
									boxtop.x - 7 - textsize.x,
									boxtop.y + clamp(boxsize.h + ySizeBar - 8, -4, boxsize.h - 10)
								)
								allesp.hptext[i].Visible = true
							end
						elseif menu:GetVal("Visuals", "Player ESP", "Health Number") then
							allesp.hptext[i].Text = tostring(health)
							local textsize = allesp.hptext[i].TextBounds
							allesp.hptext[i].Position = Vector2.new(boxtop.x - 2 - textsize.x, boxtop.y - 4)
							allesp.hptext[i].Visible = true
						end
					end
					if menu:GetVal("Visuals", "Player ESP", "Name") then
						local name_pos = Vector2.new(math.floor(boxtop.x + boxsize.w * 0.5), math.floor(boxtop.y - 15))
						allesp.name[i].Text = v.Name
						allesp.name[i].Position = name_pos
						allesp.name[i].Visible = true
					end
					local y_spot = 0
					if menu:GetVal("Visuals", "Player ESP", "Team") then
						if v.Team == nil then
							allesp.team[i].Text = "None"
						else
							allesp.team[i].Text = v.Team.Name
						end
						if menu:GetVal("Visuals", "Player ESP", "Team Color Based") then
							if v.Team == nil then
								allesp.team[i].Color = RGB(255, 255, 255)
							else
								allesp.team[i].Color = v.TeamColor.Color
							end
						end
						local team_pos = Vector2.new(math.floor(boxtop.x + boxsize.w * 0.5), boxtop.y + boxsize.h)
						allesp.team[i].Position = team_pos
						allesp.team[i].Visible = true
						y_spot += 14
					end
					if menu:GetVal("Visuals", "Player ESP", "Distance") then
						local dist_pos = Vector2.new(math.floor(boxtop.x + boxsize.w * 0.5), boxtop.y + boxsize.h + y_spot)
						allesp.distance[i].Text = tostring(math.ceil(LOCAL_PLAYER:DistanceFromCharacter(rootpart) / 5))
							.. "m"
						allesp.distance[i].Position = dist_pos
						allesp.distance[i].Visible = true
					end
				end
			end
		end)
	end)

	menu.connections.playerjoined = Players.PlayerAdded:Connect(function(player)
		updateplist()
		if plist[1] ~= nil then
			setplistinfo(selectedPlayer)
		else
			setplistinfo(nil)
		end
	end)

	menu.connections.playerleft = Players.PlayerRemoving:Connect(function(player)
		updateplist()
	end)
	--!SECTION
elseif menu.game == "dust" then --SECTION DUST BEGIN
	local allesp = {
		name = {},
		outerbox = {},
		box = {},
		innerbox = {},

		healthouter = {},
		healthinner = {},

		hptext = {},

		item = {},

		downed = {},

		distance = {},
	}

	local maxplyrs = Players.MaxPlayers

	for i = 1, maxplyrs do
		Draw:OutlinedRect(false, 20, 20, 20, 20, { 0, 0, 0, 220 }, allesp.outerbox)
		Draw:OutlinedRect(false, 20, 20, 20, 20, { 0, 0, 0, 220 }, allesp.innerbox)
		Draw:OutlinedRect(false, 20, 20, 20, 20, { 255, 255, 255, 255 }, allesp.box)

		Draw:FilledRect(false, 20, 20, 4, 20, { 10, 10, 10, 215 }, allesp.healthouter)
		Draw:FilledRect(false, 20, 20, 20, 20, { 255, 255, 255, 255 }, allesp.healthinner)
		Draw:OutlinedText("", 1, false, 20, 20, 13, false, { 255, 255, 255, 255 }, { 0, 0, 0 }, allesp.hptext)

		Draw:OutlinedText("", 2, false, 20, 20, 13, true, { 255, 255, 255, 255 }, { 0, 0, 0 }, allesp.distance)

		Draw:OutlinedText("", 2, false, 20, 20, 13, true, { 255, 255, 255, 255 }, { 0, 0, 0 }, allesp.item)

		Draw:OutlinedText("DOWNED", 2, false, 20, 20, 13, true, { 255, 255, 255, 255 }, { 0, 0, 0 }, allesp.downed)

		Draw:OutlinedText("", 2, false, 20, 20, 13, true, { 255, 255, 255, 255 }, { 0, 0, 0 }, allesp.name)
	end

	local function GetPlayerHealth(player)
		local humanoid = player.Character:FindFirstChild("Humanoid")

		local down, hp, maxhp = false, 30, 100

		if humanoid.Health > 35 then
			hp = math.ceil(humanoid.Health - 35)
		else
			down = true
			maxhp = 35
			hp = math.ceil(humanoid.Health)
		end

		return down, hp, maxhp
	end

	menu.connections.esprenderloop = game.RunService.RenderStepped:Connect(function()
		for k, v in pairs(allesp) do
			for k1, v1 in ipairs(v) do
				v1.Visible = false
			end
		end

		if menu:GetVal("Visuals", "World Visuals", "Force Time") then
			game.Lighting.ClockTime = menu:GetVal("Visuals", "World Visuals", "Custom Time")
		end

		if menu:GetVal("Visuals", "Player ESP", "Enabled") then
			local priority_color = menu:GetVal("Visuals", "ESP Settings", "Highlight Priority", COLOR, true)
			local priority_alpha = menu:GetVal("Visuals", "ESP Settings", "Highlight Priority", COLOR)[4] / 255

			local friend_color = menu:GetVal("Visuals", "ESP Settings", "Highlight Friends", COLOR, true)
			local friend_alpha = menu:GetVal("Visuals", "ESP Settings", "Highlight Friends", COLOR)[4] / 255

			for i, player in pairs(Players:GetPlayers()) do
				if not player.Character or not player.Character.Humanoid or player == LOCAL_PLAYER then
					continue
				end
				local humanoid = player.Character:FindFirstChild("Humanoid")

				local cam = Camera.CFrame

				if player.Character:FindFirstChild("UpperTorso") == nil or player.Character:FindFirstChild("Head") == nil
				then
					continue
				end
				local torso = player.Character.UpperTorso.CFrame
				local head = player.Character.Head.CFrame
				-- local vTop = torso.Position + (torso.UpVector * 1.8) + cam.UpVector
				-- local vBottom = torso.Position - (torso.UpVector * 2.5) - cam.UpVector
				local top, top_isrendered = workspace.CurrentCamera:WorldToViewportPoint(head.Position + (torso.UpVector * 1.3) + cam.UpVector)
				local bottom, bottom_isrendered = workspace.CurrentCamera:WorldToViewportPoint(torso.Position - (torso.UpVector * 3) - cam.UpVector)
				

				local minY = math.abs(bottom.y - top.y)
				local sizeX = math.ceil(math.max(clamp(math.abs(bottom.x - top.x) * 2, 0, minY), minY / 2))
				local sizeY = math.ceil(math.max(minY, sizeX * 0.5))

				local down, health, maxhealth = GetPlayerHealth(player)

				if top_isrendered or bottom_isrendered then
					local boxtop = Vector2.new(
						math.floor(top.x * 0.5 + bottom.x * 0.5 - sizeX * 0.5),
						math.floor(math.min(top.y, bottom.y))
					)
					local boxsize = { w = sizeX, h = sizeY }

					if menu:GetVal("Visuals", "Player ESP", "Box") then
						local boxtrans = menu:GetVal("Visuals", "Player ESP", "Box", COLOR)[4]

						allesp.outerbox[i].Position = Vector2.new(boxtop.x - 1, boxtop.y - 1)
						allesp.outerbox[i].Size = Vector2.new(boxsize.w + 2, boxsize.h + 2)
						allesp.outerbox[i].Visible = true
						allesp.outerbox[i].Transparency = (boxtrans - 40) / 255

						allesp.innerbox[i].Position = Vector2.new(boxtop.x + 1, boxtop.y + 1)
						allesp.innerbox[i].Size = Vector2.new(boxsize.w - 2, boxsize.h - 2)
						allesp.innerbox[i].Visible = true
						allesp.innerbox[i].Transparency = (boxtrans - 40) / 255

						allesp.box[i].Position = Vector2.new(boxtop.x, boxtop.y)
						allesp.box[i].Size = Vector2.new(boxsize.w, boxsize.h)
						allesp.box[i].Visible = true
						allesp.box[i].Transparency = boxtrans / 255
					end

					if menu:GetVal("Visuals", "Player ESP", "Health Bar") then
						allesp.healthouter[i].Position = Vector2.new(boxtop.x - 6, boxtop.y - 1)
						allesp.healthouter[i].Size = Vector2.new(4, boxsize.h + 2)
						allesp.healthouter[i].Visible = true

						local ySizeBar = -math.floor(boxsize.h * health / maxhealth)

						allesp.healthinner[i].Position = Vector2.new(boxtop.x - 5, boxtop.y + boxsize.h)
						allesp.healthinner[i].Size = Vector2.new(2, ySizeBar)
						allesp.healthinner[i].Visible = true
						allesp.healthinner[i].Color = ColorRange(health, {
							[1] = {
								start = 0,
								color = menu:GetVal("Visuals", "Player ESP", "Health Bar", COLOR1, true),
							},
							[2] = {
								start = 100,
								color = menu:GetVal("Visuals", "Player ESP", "Health Bar", COLOR2, true),
							},
						})

						if menu:GetVal("Visuals", "Player ESP", "Health Number") then
							allesp.hptext[i].Text = tostring(health)
							local textsize = allesp.hptext[i].TextBounds
							allesp.hptext[i].Position = Vector2.new(
								boxtop.x - 7 - textsize.x,
								boxtop.y + clamp(boxsize.h + ySizeBar - 8, -4, boxsize.h - 10)
							)
							allesp.hptext[i].Visible = true
						end
					elseif menu:GetVal("Visuals", "Player ESP", "Health Number") then
						allesp.hptext[i].Text = tostring(health)
						local textsize = allesp.hptext[i].TextBounds
						allesp.hptext[i].Position = Vector2.new(boxtop.x - 2 - textsize.x, boxtop.y - 4)
						allesp.hptext[i].Visible = true
					end

					local y_spot = 0
					if menu:GetVal("Visuals", "Player ESP", "Name") then
						local name_pos = Vector2.new(math.floor(boxtop.x + boxsize.w * 0.5), math.floor(boxtop.y - 15))
						allesp.name[i].Text = player.Name
						allesp.name[i].Position = name_pos
						allesp.name[i].Visible = true
						y_spot += 14
					end

					if menu:GetVal("Visuals", "Player ESP", "Downed") and down then
						local downed_pos = Vector2.new(
								math.floor(boxtop.x + boxsize.w * 0.5),
								math.floor(boxtop.y - 15) - y_spot
							)
						allesp.downed[i].Position = downed_pos
						allesp.downed[i].Visible = true
					end

					local y_spot = 0
					if menu:GetVal("Visuals", "Player ESP", "Held Item") then
						local held_pos = Vector2.new(math.floor(boxtop.x + boxsize.w * 0.5), boxtop.y + boxsize.h)

						local heldwep = "Nothing"
						for k, v in pairs(player.Character:GetChildren()) do
							if v.ClassName == "Model" then
								if v:FindFirstChild("Handle") ~= nil then
									heldwep = v.Name
									break
								end
							end
						end
						allesp.item[i].Text = heldwep
						allesp.item[i].Position = held_pos
						allesp.item[i].Visible = true
						y_spot += 14
					end
					if menu:GetVal("Visuals", "Player ESP", "Distance") then
						local dist_pos = Vector2.new(math.floor(boxtop.x + boxsize.w * 0.5), boxtop.y + boxsize.h + y_spot)
						allesp.distance[i].Text = tostring(math.ceil(LOCAL_PLAYER:DistanceFromCharacter(torso.Position) / 5))
							.. "m"
						allesp.distance[i].Position = dist_pos
						allesp.distance[i].Visible = true
					end

					if menu:GetVal("Visuals", "ESP Settings", "Highlight Priority") and table.find(menu.priority, player.Name)
					then
						allesp.name[i].Color = priority_color
						allesp.name[i].Transparency = priority_alpha

						allesp.box[i].Color = priority_color

						allesp.item[i].Color = priority_color
						allesp.item[i].Transparency = priority_alpha

						allesp.distance[i].Color = priority_color
						allesp.distance[i].Transparency = priority_alpha

						allesp.downed[i].Color = priority_color
						allesp.downed[i].Transparency = priority_alpha
					elseif menu:GetVal("Visuals", "ESP Settings", "Highlight Friends") and table.find(menu.friends, player.Name)
					then
						allesp.name[i].Color = friend_color
						allesp.name[i].Transparency = friend_alpha

						allesp.box[i].Color = friend_color

						allesp.item[i].Color = friend_color
						allesp.item[i].Transparency = friend_alpha

						allesp.distance[i].Color = friend_color
						allesp.distance[i].Transparency = friend_alpha

						allesp.downed[i].Color = friend_color
						allesp.downed[i].Transparency = friend_alpha
					else
						allesp.name[i].Color = menu:GetVal("Visuals", "Player ESP", "Name", COLOR, true)
						allesp.name[i].Transparency = menu:GetVal("Visuals", "Player ESP", "Name", COLOR)[4] / 255

						allesp.box[i].Color = menu:GetVal("Visuals", "Player ESP", "Box", COLOR, true)

						allesp.item[i].Color = menu:GetVal("Visuals", "Player ESP", "Held Item", COLOR, true)
						allesp.item[i].Transparency = menu:GetVal("Visuals", "Player ESP", "Held Item", COLOR)[4] / 255

						allesp.distance[i].Color = menu:GetVal("Visuals", "Player ESP", "Distance", COLOR, true)
						allesp.distance[i].Transparency = menu:GetVal("Visuals", "Player ESP", "Distance", COLOR)[4] / 255

						allesp.downed[i].Color = menu:GetVal("Visuals", "Player ESP", "Downed", COLOR, true)
						allesp.downed[i].Transparency = menu:GetVal("Visuals", "Player ESP", "Downed", COLOR)[4] / 255
					end
				end
			end
		end
	end)

	menu.Initialize({
		{
			name = "Legit",
			content = {},
		},
		{
			name = "Rage",
			content = {},
		},
		{
			name = "Visuals",
			content = {
				{
					name = "Player ESP",
					autopos = "left",
					content = {
						{
							type = TOGGLE,
							name = "Enabled",
							value = true,
						},
						{
							type = TOGGLE,
							name = "Downed",
							value = true,
							extra = {
								type = COLORPICKER,
								name = "Player Downed Flag Color",
								color = { 252, 186, 3, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Name",
							value = true,
							extra = {
								type = COLORPICKER,
								name = "Player Name Color",
								color = { 255, 255, 255, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Box",
							value = true,
							extra = {
								type = COLORPICKER,
								name = "Player Box Color",
								color = { 255, 0, 0, 200 },
							},
						},
						{
							type = TOGGLE,
							name = "Health Bar",
							value = true,
							extra = {
								type = DOUBLE_COLORPICKER,
								name = { "Low Health", "Max Health" },
								color = { { 255, 0, 0 }, { 0, 255, 0 } },
							},
						},
						{
							type = TOGGLE,
							name = "Health Number",
							value = true,
							extra = {
								type = COLORPICKER,
								name = "Player Health Number Color",
								color = { 255, 255, 255, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Held Item",
							value = true,
							extra = {
								type = COLORPICKER,
								name = "Player Held Item Color",
								color = { 255, 255, 255, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Distance",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Player Distance Color",
								color = { 255, 255, 255, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Chams",
							value = true,
							extra = {
								type = DOUBLE_COLORPICKER,
								name = { "Visible Player Chams", "Invisible Player Chams" },
								color = { { 255, 0, 0, 200 }, { 100, 0, 0, 100 } },
							},
						},
						{
							type = TOGGLE,
							name = "Skeleton",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Player Skeleton Color",
								color = { 255, 255, 255, 180 },
							},
						},
						{
							type = TOGGLE,
							name = "Out of View",
							value = true,
							extra = {
								type = COLORPICKER,
								name = "Arrow Color",
								color = { 255, 255, 255, 255 },
							},
						},
						{
							type = SLIDER,
							name = "Arrow Distance",
							value = 50,
							minvalue = 10,
							maxvalue = 100,
							stradd = "%",
						},
						{
							type = TOGGLE,
							name = "Dynamic Arrow Size",
							value = true,
						},
					},
				},
				{
					name = "ESP Settings",
					autopos = "left",
					autofill = true,
					content = {
						{
							type = SLIDER,
							name = "Max HP Visibility Cap",
							value = 90,
							minvalue = 50,
							maxvalue = 100,
							stradd = "hp",
						},
						{
							type = COMBOBOX,
							name = "Ignore",
							values = { { "Distance", false }, { "Down", false }, { "Party", false } },
						},
						{
							type = SLIDER,
							name = "Max Distance",
							value = 100,
							minvalue = 30,
							maxvalue = 500,
							stradd = "m",
						},
						{
							type = TOGGLE,
							name = "Highlight Aimbot Target",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Aimbot Target",
								color = { 255, 0, 0, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Highlight Friends",
							value = true,
							extra = {
								type = COLORPICKER,
								name = "Friended Players",
								color = { 0, 255, 255, 255 },
							},
						},
						{
							type = TOGGLE,
							name = "Highlight Priority",
							value = true,
							extra = {
								type = COLORPICKER,
								name = "Priority Players",
								color = { 255, 210, 0, 255 },
							},
						},
					},
				},
				{
					name = "Misc",
					autopos = "right",
					content = {
						{
							type = TOGGLE,
							name = "Custom Crosshair",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Crosshair Color",
								color = { 255, 255, 255, 255 },
							},
						},

						{
							type = DROPBOX,
							name = "Crosshair Position",
							value = 1,
							values = { "Center Of Screen", "Mouse" },
						},
						{
							type = SLIDER,
							name = "Crosshair Size",
							value = 10,
							minvalue = 5,
							maxvalue = 15,
							stradd = "px",
						},
						{
							type = TOGGLE,
							name = "Draw Aimbot FOV",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Aimbot FOV Circle Color",
								color = { 255, 255, 255, 255 },
							},
						},
					},
				},
				{
					name = "World Visuals",
					autopos = "right",
					content = {
						{
							type = TOGGLE,
							name = "Force Time",
							value = false,
						},
						{
							type = SLIDER,
							name = "Custom Time",
							value = 0,
							minvalue = 0,
							maxvalue = 24,
							decimal = 0.1,
						},
					},
				},
				{
					name = "Dropped Esp",
					autopos = "right",
					autofill = true,
					content = {},
				},
			},
		},
		{
			name = "Misc",
			content = {
				{
					name = "Movement",
					autopos = "left",
					autofill = true,
					content = {
						{
							type = TOGGLE,
							name = "Speed",
							value = false,
						},
						{
							type = SLIDER,
							name = "Speed Factor",
							value = 40,
							minvalue = 1,
							maxvalue = 200,
							stradd = " stud/s",
						},
						{
							type = DROPBOX,
							name = "Speed Method",
							value = 1,
							values = { "Velocity", "Walk Speed" },
						},
						{
							type = TOGGLE,
							name = "Fly",
							value = false,
							extra = {
								type = KEYBIND,
								key = Enum.KeyCode.B,
							},
						},
						{
							type = DROPBOX,
							name = "Fly Method",
							value = 1,
							values = { "Fly", "Noclip" },
						},
						{
							type = SLIDER,
							name = "Fly Speed",
							value = 40,
							minvalue = 1,
							maxvalue = 200,
							stradd = " stud/s",
						},
						{
							type = TOGGLE,
							name = "Mouse Teleport",
							value = false,
							extra = {
								type = KEYBIND,
								key = Enum.KeyCode.Q,
							},
						},
					},
				},
			},
		},
		{
			name = "Settings",
			content = {
				{
					name = "Player List",
					x = menu.columns.left,
					y = 66,
					width = menuWidth - 34, -- this does nothing?
					height = 328,
					content = {
						{
							type = "list",
							name = "Players",
							multiname = { "Name", "Team", "Status" },
							size = 9,
							columns = 3,
						},
						{
							type = IMAGE,
							name = "Player Info",
							text = "No Player Selected",
							size = 72,
						},
						{
							type = DROPBOX,
							name = "Player Status",
							x = 307,
							y = 314,
							w = 160,
							value = 1,
							values = { "None", "Friend", "Priority" },
						},
					},
				},
				{
					name = "Cheat Settings",
					x = menu.columns.left,
					y = 400,
					width = menu.columns.width,
					height = 182,
					content = {
						{
							type = TOGGLE,
							name = "Menu Accent",
							value = false,
							extra = {
								type = COLORPICKER,
								name = "Accent Color",
								color = { 127, 72, 163 },
							},
						},
						{
							type = TOGGLE,
							name = "Watermark",
							value = true,
						},
						{
							type = TOGGLE,
							name = "Custom Menu Name",
							value = MenuName and true or false,
						},
						{
							type = TEXTBOX,
							name = "MenuName",
							text = MenuName or "Bitch Bot",
						},
						{
							type = BUTTON,
							name = "Set Clipboard Game ID",
						},
						{
							type = BUTTON,
							name = "Unload Cheat",
							doubleclick = true,
						},
						{
							type = TOGGLE,
							name = "Allow Unsafe Features",
							value = false,
						},
					},
				},
				{
					name = "Configuration",
					x = menu.columns.right,
					y = 400,
					width = menu.columns.width,
					height = 182,
					content = {
						{
							type = TEXTBOX,
							name = "ConfigName",
							file = true,
							text = "",
						},
						{
							type = DROPBOX,
							name = "Configs",
							value = 1,
							values = GetConfigs(),
						},
						{
							type = BUTTON,
							name = "Load Config",
							doubleclick = true,
						},
						{
							type = BUTTON,
							name = "Save Config",
							doubleclick = true,
						},
						{
							type = BUTTON,
							name = "Delete Config",
							doubleclick = true,
						},
					},
				},
			},
		},
	})

	local selectedPlayer = nil
	local plistinfo = menu.options["Settings"]["Player List"]["Player Info"][1]
	local plist = menu.options["Settings"]["Player List"]["Players"]
	local function updateplist()
		if menu == nil then
			return
		end
		local playerlistval = menu:GetVal("Settings", "Player List", "Players")
		local playerz = {}

		for i, team in pairs(TEAMS:GetTeams()) do
			local sorted_players = {}
			for i1, player in pairs(team:GetPlayers()) do
				table.insert(sorted_players, player.Name)
			end
			table.sort(sorted_players)
			for i1, player_name in pairs(sorted_players) do
				table.insert(playerz, Players:FindFirstChild(player_name))
			end
		end

		local sorted_players = {}
		for i, player in pairs(Players:GetPlayers()) do
			if player.Team == nil then
				table.insert(sorted_players, player.Name)
			end
		end
		table.sort(sorted_players)
		for i, player_name in pairs(sorted_players) do
			table.insert(playerz, Players:FindFirstChild(player_name))
		end
		sorted_players = nil

		local templist = {}
		for k, v in pairs(playerz) do
			local plyrname = { v.Name, RGB(255, 255, 255) }
			local teamtext = { "None", RGB(255, 255, 255) }
			local plyrstatus = { "None", RGB(255, 255, 255) }
			if v.Team ~= nil then
				teamtext[1] = v.Team.Name
				teamtext[2] = v.TeamColor.Color
			end
			if v == LOCAL_PLAYER then
				plyrstatus[1] = "Local Player"
				plyrstatus[2] = RGB(66, 135, 245)
			elseif table.find(menu.friends, v.Name) then
				plyrstatus[1] = "Friend"
				plyrstatus[2] = RGB(0, 255, 0)
			elseif table.find(menu.priority, v.Name) then
				plyrstatus[1] = "Priority"
				plyrstatus[2] = RGB(255, 210, 0)
			end

			table.insert(templist, { plyrname, teamtext, plyrstatus })
		end
		plist[5] = templist
		if playerlistval ~= nil then
			for i, v in ipairs(playerz) do
				if v.Name == playerlistval then
					selectedPlayer = v
					break
				end
				if i == #playerz then
					selectedPlayer = nil
					menu.list.setval(plist, nil)
				end
			end
		end
		menu:SetMenuPos(menu.x, menu.y)
	end

	local function setplistinfo(player, textonly)
		if not menu then
			return
		end
		if player ~= nil then
			local playerhealth = "?"
			local playerdown = "?"
			if player.Character ~= nil then
				local down, hp, maxhp = GetPlayerHealth(player)

				playerdown = tostring(down)

				playerhealth = tostring(hp) .. "/" .. tostring(maxhp)
			end

			plistinfo[1].Text = "Name: " .. player.Name .. "\nDown: " .. playerdown .. "\nHealth: " .. playerhealth

			if textonly == nil then
				plistinfo[2].Data = BBOT_IMAGES[5]
				plistinfo[2].Data = game:HttpGet(string.format(
					"https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=100&height=100&format=png",
					player.UserId
				))
			end
		else
			plistinfo[2].Data = BBOT_IMAGES[5]
			plistinfo[1].Text = "No Player Selected"
		end
	end

	menu.list.removeall(menu.options["Settings"]["Player List"]["Players"])
	updateplist()
	setplistinfo(nil)

	menu.connections.renderstepp2 = game.RunService.RenderStepped:Connect(function()
		if menu.open then
			if menu.tabnames[menu.activetab] == "Settings" then
				if plist[1] ~= nil then
					setplistinfo(selectedPlayer, true)
				end
			end
		end
	end)

	menu.connections.inputstart2 = INPUT_SERVICE.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if menu.open then
				if menu.tabnames[menu.activetab] == "Settings" and menu.open then
					game.RunService.Stepped:wait()

					updateplist()

					if selectedPlayer ~= nil then
						if menu:MouseInMenu(28, 68, 448, 238) then
							if table.find(menu.friends, selectedPlayer.Name) then
								menu.options["Settings"]["Player List"]["Player Status"][1] = 2
								menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "Friend"
							elseif table.find(menu.priority, selectedPlayer.Name) then
								menu.options["Settings"]["Player List"]["Player Status"][1] = 3
								menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "Priority"
							else
								menu.options["Settings"]["Player List"]["Player Status"][1] = 1
								menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "None"
							end
						end

						for k, table_ in pairs({ menu.friends, menu.priority }) do
							for index, plyrname in pairs(table_) do
								if selectedPlayer.Name == plyrname then
									table.remove(table_, index)
								end
							end
						end
						if menu:GetVal("Settings", "Player List", "Player Status") == 2 then
							if not table.find(menu.friends, selectedPlayer.Name) then
								table.insert(menu.friends, selectedPlayer.Name)
								WriteRelations()
							end
						elseif menu:GetVal("Settings", "Player List", "Player Status") == 3 then
							if not table.find(menu.priority, selectedPlayer.Name) then
								table.insert(menu.priority, selectedPlayer.Name)
								WriteRelations()
							end
						end
					else
						menu.options["Settings"]["Player List"]["Player Status"][1] = 1
						menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "None"
					end

					updateplist()

					if plist[1] ~= nil then
						if oldslectedplyr ~= selectedPlayer then
							setplistinfo(selectedPlayer)
							oldslectedplyr = selectedPlayer
						end
					else
						setplistinfo(nil)
					end
				end
			end
		end
	end)

	menu.connections.playerjoined = Players.PlayerAdded:Connect(function(player)
		updateplist()
		if plist[1] ~= nil then
			setplistinfo(selectedPlayer)
		else
			setplistinfo(nil)
		end
	end)

	menu.connections.playerleft = Players.PlayerRemoving:Connect(function(player)
		updateplist()
	end)
	--!SECTION
elseif menu.game == "pf" then --SECTION PF BEGIN
	local client = {}
	local legitbot = {}
	local misc = { adornments = {} }
	local ragebot = { flip = false }
	local camera = {}
	menu.crosshair = { outline = {}, inner = {} }
	for i, v in pairs(menu.crosshair) do
		for i = 1, 2 do
			Draw:FilledRect(false, 20, 20, 20, 20, { 10, 10, 10, 215 }, v)
		end
	end

	local gunicons = {
		["AK12"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABEAQAAAADsUUeQAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAscFL8zDEgAAADXSURBVDjL5dFLDsIgEAbgGV30FsaDGDmFew/h2pJ4kR6lR+kRSNx0MYI8bEPbGROa2I3/ghC+AMMA8N+x48yFvC432jWcpPQTwUwICYA48ZbJnhXl5hmkZgRZITiJcge0Vc+dliKLXis6f6kvy2C6x4YeUFunXqIfDRxi1RT6NkpIJjCVT75IH+UqypERE3+7WYozobane7B70HX+TQvpJPGLfpXd0w5i5qKDtIyEVFH6YsFi0cWCDgQBJUolSjyRNhFYJXYbqd02ovzHFotYteokOcMv8wb1yY8+lRZmrQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6Mjg6MjAtMDQ6MDAntofaAAAAAElFTkSuQmCC", 200, 68},
		["AK47"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA5CAYAAABzlmQiAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAK7SURBVHhe7dvhVoQgEIbh3e7/nisMizwyIg4wA+/zp7JdhWE+cTun9wvufH57f4s/bsKx+O2p4+tXdqyVVBuKpiAUvEcDHhfWkh7z15CrYW78SwTEcmPNxnpQCMgJAuJH64ARkAPC4VOroJz1g3StaQNCMPzTDkmuJ6TrfMSvUyEckIRABPFH0ZQBgSz2xz/xV6fiS37Fw0vYJmvhjqtVeHaP8WrXMrd2Gr0h9YV0/rf0xtHOBm55vPgjNV2OtLY150vVntt0QIDejmHhMwiQOG4Y7CCAgB0EyAiPW+wgWN7xc0eKgECF1GTWpD1/NW4CMjlPjWsRATHmbkOn60cY9BGQE2mjhfpIjaddP+la6M99QK4aqmZ+6TnD+6Vr1Jz/inQ99OXyz7yhgXbxkKq96Vs0P3xxE5CYh0081FzPa8EmU49YrRqyZo7pWML7c2OrOfeV3LXQ39CA9GqEmjmWjq1V/XrVBrKuARm16DVzLBnrft7ca2uuuyu5PtprGpCwyOH8oxe7dI77OEtfH1zN7c65UlfnRR+qAbG6qCVzbDX2J/W1Ws+VbAtQu4geFrB0bq3mUlvbwEN9Z3frz7xhwVLxMATUybdt8XJ3uRkWt+QO3nqeJWPImWENPJu++N4DEhCScab+j8KnjamFBvdr+X+59dC8VoK+ouUD0gu7iE/TBmS2uy67yBhL7yC97+pPr0dI+uMRCxAQkM7YRXxZOiCjmo2Q+DFtQEqa8GmjjkRI+nDbIHcdG8pCODSa3HPIPaC4gxES2/iQPgGNkOEcdx4DtBqcnUQfBTWCkNjEI9ZktIKGH9xtDNFsbnYSHRTRGI2QEA49PGIZQ3PbwmIYVbuTEDBdFNOwuyEhHPp4xDKMhh+PBXCgZCchTG1QVCekkBCOdiisI2chIRxt8RnEEcIAFJIeuaDl9foC5XFwqQZYXeYAAAAASUVORK5CYII=", 200, 57},
		["AKM"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA5CAYAAABzlmQiAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAK7SURBVHhe7dvhVoQgEIbh3e7/nisMizwyIg4wA+/zp7JdhWE+cTun9wvufH57f4s/bsKx+O2p4+tXdqyVVBuKpiAUvEcDHhfWkh7z15CrYW78SwTEcmPNxnpQCMgJAuJH64ARkAPC4VOroJz1g3StaQNCMPzTDkmuJ6TrfMSvUyEckIRABPFH0ZQBgSz2xz/xV6fiS37Fw0vYJmvhjqtVeHaP8WrXMrd2Gr0h9YV0/rf0xtHOBm55vPgjNV2OtLY150vVntt0QIDejmHhMwiQOG4Y7CCAgB0EyAiPW+wgWN7xc0eKgECF1GTWpD1/NW4CMjlPjWsRATHmbkOn60cY9BGQE2mjhfpIjaddP+la6M99QK4aqmZ+6TnD+6Vr1Jz/inQ99OXyz7yhgXbxkKq96Vs0P3xxE5CYh0081FzPa8EmU49YrRqyZo7pWML7c2OrOfeV3LXQ39CA9GqEmjmWjq1V/XrVBrKuARm16DVzLBnrft7ca2uuuyu5PtprGpCwyOH8oxe7dI77OEtfH1zN7c65UlfnRR+qAbG6qCVzbDX2J/W1Ws+VbAtQu4geFrB0bq3mUlvbwEN9Z3frz7xhwVLxMATUybdt8XJ3uRkWt+QO3nqeJWPImWENPJu++N4DEhCScab+j8KnjamFBvdr+X+59dC8VoK+ouUD0gu7iE/TBmS2uy67yBhL7yC97+pPr0dI+uMRCxAQkM7YRXxZOiCjmo2Q+DFtQEqa8GmjjkRI+nDbIHcdG8pCODSa3HPIPaC4gxES2/iQPgGNkOEcdx4DtBqcnUQfBTWCkNjEI9ZktIKGH9xtDNFsbnYSHRTRGI2QEA49PGIZQ3PbwmIYVbuTEDBdFNOwuyEhHPp4xDKMhh+PBXCgZCchTG1QVCekkBCOdiisI2chIRxt8RnEEcIAFJIeuaDl9foC5XFwqQZYXeYAAAAASUVORK5CYII=", 200, 57},
		["AK74"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA5CAYAAABzlmQiAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAK7SURBVHhe7dvhVoQgEIbh3e7/nisMizwyIg4wA+/zp7JdhWE+cTun9wvufH57f4s/bsKx+O2p4+tXdqyVVBuKpiAUvEcDHhfWkh7z15CrYW78SwTEcmPNxnpQCMgJAuJH64ARkAPC4VOroJz1g3StaQNCMPzTDkmuJ6TrfMSvUyEckIRABPFH0ZQBgSz2xz/xV6fiS37Fw0vYJmvhjqtVeHaP8WrXMrd2Gr0h9YV0/rf0xtHOBm55vPgjNV2OtLY150vVntt0QIDejmHhMwiQOG4Y7CCAgB0EyAiPW+wgWN7xc0eKgECF1GTWpD1/NW4CMjlPjWsRATHmbkOn60cY9BGQE2mjhfpIjaddP+la6M99QK4aqmZ+6TnD+6Vr1Jz/inQ99OXyz7yhgXbxkKq96Vs0P3xxE5CYh0081FzPa8EmU49YrRqyZo7pWML7c2OrOfeV3LXQ39CA9GqEmjmWjq1V/XrVBrKuARm16DVzLBnrft7ca2uuuyu5PtprGpCwyOH8oxe7dI77OEtfH1zN7c65UlfnRR+qAbG6qCVzbDX2J/W1Ws+VbAtQu4geFrB0bq3mUlvbwEN9Z3frz7xhwVLxMATUybdt8XJ3uRkWt+QO3nqeJWPImWENPJu++N4DEhCScab+j8KnjamFBvdr+X+59dC8VoK+ouUD0gu7iE/TBmS2uy67yBhL7yC97+pPr0dI+uMRCxAQkM7YRXxZOiCjmo2Q+DFtQEqa8GmjjkRI+nDbIHcdG8pCODSa3HPIPaC4gxES2/iQPgGNkOEcdx4DtBqcnUQfBTWCkNjEI9ZktIKGH9xtDNFsbnYSHRTRGI2QEA49PGIZQ3PbwmIYVbuTEDBdFNOwuyEhHPp4xDKMhh+PBXCgZCchTG1QVCekkBCOdiisI2chIRxt8RnEEcIAFJIeuaDl9foC5XFwqQZYXeYAAAAASUVORK5CYII=", 200, 57},
		["AK108"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA5CAYAAABzlmQiAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAK7SURBVHhe7dvhVoQgEIbh3e7/nisMizwyIg4wA+/zp7JdhWE+cTun9wvufH57f4s/bsKx+O2p4+tXdqyVVBuKpiAUvEcDHhfWkh7z15CrYW78SwTEcmPNxnpQCMgJAuJH64ARkAPC4VOroJz1g3StaQNCMPzTDkmuJ6TrfMSvUyEckIRABPFH0ZQBgSz2xz/xV6fiS37Fw0vYJmvhjqtVeHaP8WrXMrd2Gr0h9YV0/rf0xtHOBm55vPgjNV2OtLY150vVntt0QIDejmHhMwiQOG4Y7CCAgB0EyAiPW+wgWN7xc0eKgECF1GTWpD1/NW4CMjlPjWsRATHmbkOn60cY9BGQE2mjhfpIjaddP+la6M99QK4aqmZ+6TnD+6Vr1Jz/inQ99OXyz7yhgXbxkKq96Vs0P3xxE5CYh0081FzPa8EmU49YrRqyZo7pWML7c2OrOfeV3LXQ39CA9GqEmjmWjq1V/XrVBrKuARm16DVzLBnrft7ca2uuuyu5PtprGpCwyOH8oxe7dI77OEtfH1zN7c65UlfnRR+qAbG6qCVzbDX2J/W1Ws+VbAtQu4geFrB0bq3mUlvbwEN9Z3frz7xhwVLxMATUybdt8XJ3uRkWt+QO3nqeJWPImWENPJu++N4DEhCScab+j8KnjamFBvdr+X+59dC8VoK+ouUD0gu7iE/TBmS2uy67yBhL7yC97+pPr0dI+uMRCxAQkM7YRXxZOiCjmo2Q+DFtQEqa8GmjjkRI+nDbIHcdG8pCODSa3HPIPaC4gxES2/iQPgGNkOEcdx4DtBqcnUQfBTWCkNjEI9ZktIKGH9xtDNFsbnYSHRTRGI2QEA49PGIZQ3PbwmIYVbuTEDBdFNOwuyEhHPp4xDKMhh+PBXCgZCchTG1QVCekkBCOdiisI2chIRxt8RnEEcIAFJIeuaDl9foC5XFwqQZYXeYAAAAASUVORK5CYII=", 200, 57},
		["AN-94"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABUCAYAAADH/HimAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAALnSURBVHhe7dpBbpwwFABQkib3P1i77zq7nqFp08YRSJYFjDEGDLy3GQaMbfj/YzJKBwAAAAAAAAAAAAAAAAAA9/bUf8Lh/n3qN7unT/3moZ77z9uLgwODW68gj4riqKdYS8W69z0Yrv2oe5+6ZYG0lICtu3uB3OoVK9z8oP9KY1qMzW1WEIVRZs8neRyjqXGHNsPx+JxBODa1v9/MpkCYVZJUpeIYhXG3itmSa1Ig3FJukdzibxDFQalLriAKgilLXq+C7MaS7p6WJtRScV6VjJXmZdzH3LFcCoRZJUmVys2dGmPVpkBohgK5kN/v75/3pOteX751z8/+pW2tFosjENkCfz8+ure3X92P7z+/tnOFJEj1h5pVMsecc0KbWL+7OdkTu9IKMgQkXNNYcNJrDW3ifWHz/c+fr8/Xl5fJFWSs71Tcb4tyrmHK1LWt6XNv2RNtOZDpDZ+ba9w2tEvPHcR9hDbx91xTfadK+h6TO96e0mtrcY5zsidbK4g1PLrJU3NNzxvajfU31ccSY/2OKRkrt2/Wyb7JNRKm1JJkmJvnWD+h/dT+fnOVsb5Tc2PlnM92qiRebWuSYmmyDe3TY2k/4Xi6L0faL+fSxK9YIYli/e5d9EOOjjnsnzrO9WUHvuTpOWWrhHs0x5xx4z7S9o/6H5MzJu3apUD2SpI1c4xNzbek/72unW1sUiBHJcXcHGvMack9iB11P1hvdYG0FPy5BK41z7kxprR0j1hm8R/pIdixfvfhShIXHskukL4ePAkLKN7z8s+KMEOBLGQVvZdLFMijV5gWktpr1jndYgWRnJS65OvCUBBbrhylRdfCakY+wSqkQO5BsFZQJNfnVyyYoUAOULrysD8FsoJXpetTIAexipyDJ2AFa5LdKtQ2KwjM8PSqpGQVsXq0T4AqWVIgCuM8BKqinCJRHOciWBXNFYjCOCdBqywtEoVxbn7F2pDiAAAAAAAAAAAAAAAAAAAATq3r/gMjYHWdpkYiOAAAAABJRU5ErkJggg==", 200, 84},
		["AS VAL"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABaCAYAAAD99hnWAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAALGSURBVHhe7dnbkqIwFAVQnf//5x5CHaYdS0K4SAJZ66UNpeTC2QbaBwAAAAAAAAAAAAAAAAAA9O0Zf+nMzyBe/uc5iJejT+97f89Vza1BMs1RQDqWK5ASVw/K0vzT/AQk7C2WHvUQkD/xultpkZJo0onSa97tDiIULEk7SJcBEQ5KdX+LBTnd7CB2DbboIiDCwVZusSDjtjuIXYMjXDYgAsAZngoN5nkGgRnjD4V2EL7pSj9GT1l4HbOAdO5KBVxDNiBbF28pdEdelKW++HXkuvdiNiB7FnOpaLeee+m8Nc3NqeaYt64zv5oPyNK5akrzmMaXm9MZc8j1z3bN/hcrFVUSzea0UJBpDJM4xMGa20GWPrtk7tx7z/tu6mc679n9co5mArL0mVd7xvZqTZ+v3vtP58mNaWs/n+T64XjVb7FS8STRnJUKYxKHqvk03pI5cD1fCUhpEZcU1ZiIQTSbNI1PSO6nyg6SCimJ5kdjKgbRbF4M9zLjpcxXnkGSpQDMObPIto6xtjPXqHfNBOTsi752fDlLYz+yr+TstepZ9YDUutil45vsGefUVzrH2n4/2TMW1jn8GSQVQBLNrKtcaAXZr8MCErkoDkYSzdOVjvNI03xrzpv1ZgOypohK35uKI4lmN3qc811s3kFSKCZxaNaYikE04TKKAxJZ+CcOz4pMjOIQXE42IJGFURwq0nIo1s6Fvh32kD5uFSEOMcMaXcfugIyJGETzdlqcm13wPJsDMqZiEE24pbHA37+R7lz4a799v7UWa8fx7s7XqCXdLbKAsMZhD+mca2/AKCMgldgBrkFAIENAIENAKnKb1b7uAnKnovSg/n1d7iClIblTmNhGAVS2dxcQ4u/yDAIZvn0aYBdplx0EMgQEMmzNDdhyi+W26hwWuRFLIRGIOix6Q95DIhQAAAAAAAAAAAAAAAAAHOTx+AtMmoR15eCeLgAAAABJRU5ErkJggg==", 200, 90},
		["AUG A1"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABXAQAAAABpEzelAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAseOlHTYwUAAAD/SURBVEjH7dNBaoRAEAXQLy7cxQuEzDWyCJgj5QbTQ7Y5VA+5iJAL1NKFWOmynaDtr8WEgUCYj7joh1V2Uw3c88/zStYqtcify8B+WHVKL76ZJ6CLVBqgFSp1ekYuoWykl5isG9UrqbRfN1aSYHJgMhftXFFPKipgUhzyTybcUkZXPqhIO6wP+yJ9o9IEJsEETNKZy8O10io8GfG4l68kh4HJe5JuwMtOpjrL83asbC8mR9nLhEXeUoWNjFYSSkRMQhpCcaUvxRb0xCRmiVV0vvHkvJej3YxZyqu1yGcWbCRmWW5NkSygct5MYdEMtxP5hXjVOrrLWbxPbGruuSLf0k/tCaA++q8AAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjMwOjU4LTA0OjAwzMVfkAAAAABJRU5ErkJggg==", 200, 87},
		["AUG A2"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABWAQAAAACiT+QAAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsfEJNzm5IAAAEPSURBVEjH7dTBTsMwDAZgV51UTnQPMC2vwQGpr8SRm8OJ18reJBVIXHMjEtWMkzLWNPZOCCS0/9T6U93ESgtwzb/IRhUjFW9U2WexUqM3RCRJBkqRpM8SxIUhy6QKyb08bMktig2d4gEKaanMecM9CfF5i6qgKhLMC1kXzwNaC2gCmhx/Ut6l9zxT6BxgLa5lsYXgt8SO72wl0FHsNbG33LsW21M6jWv5YDET7Gp5UeWJZYhwX8lrM8tdJTYJCnKELAEeWYoZTEkcy0MpA8UsJEiYxYPni5XwwA8XxDWVxJM4UcYsIHQbybeLXaaYJMhSfdkmHW9RvgYxlmdtIQHk6DL8mnhFjPbI/K+85o/yCUw71uZGV8oBAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTozMToxNi0wNDowMPdyQQkAAAAASUVORK5CYII=", 200, 86},
		["AUG A3"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABPAQAAAACGlrdTAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsfJLLHbycAAAENSURBVEjH7dQxjsIwEAXQiVK421wALXuMLRC5EiXVxhLFXmGP4xUXcUfrjkhECTNxCLE9EwSIjl84kp+sTOxxAN55Nrml8ZMR1cvqLikelrUoP4x0PjaBbBCXFj1Ik04Naa+yFKWMRXVHM60piJ3WlErOwKmXgltjWDHjdsWiJalBXFPfFvWMqM4pw4km0ZIUANX4ORehzXcfvBQzQu0eywFl2cAikP58flHKmpFWefnGsw/lj6RyqbQ0AHbnNpb6IhsUmIrzYlOxNGT4sNhjgRgvJpKMesJLxssOxcRCEyhallzPCFSTaziKVRqCUAUoe9w/YDIn/8G1Dl/GR5aK+au8RgSAUkvyBe8kOQOARACASmW9iAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6MzE6MzYtMDQ6MDC1V0Z0AAAAAElFTkSuQmCC", 200, 79},
		["C7A2"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABCCAYAAAASc5kgAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAKySURBVHhe7drhcuMgDEbRdN//ndtoRrSsB4gBgyX5nj+NvW2KkT6D030BAAAAwEZf+tW97zd9+evrTV8uI793x+/BPUIHZCdCEtM//QqggIBcgNUjLgICNBAQoIGAAA0EBGjgY95JtQf0fDw8xPtFQCaVmr80FkJSdpwra/PEFmuSFDinpxEEAcFtPNxQwi771iafLdb/avWxNk+PKdrdgSEgf/JayLwcj/WlCY/YYuUFWMlaca3zMF+PCAiNa0e6WeU1sVyfkI2za8XoUWqCXeO00oC165XxpX+zMtakOpjaxZRYuqieccMeawG5ZItloSllDEIPgUtcsoKs1rqrEIpYrK0gNB5CywN3tqfznyEgwEEeEP6rCdBAQIAGAgI08AwCk/LngDu5CMinySLM8VgJSIgtlpXJRN3ZGsn3CT28XXUgu+/Ks5NifRUpXZ/1Medm65PUrvmq978aAdnAavHvkNfJw7yE+RRLJjvRUyZYG48VXuYl5Me8NKVdUhuhh+aF/TuIpyLArmoTXb2nl4bdvf8cuYbjuEbeI7fjOrHO8hVEGkTooUmt8VkfO9a6JCC1Jjqel+NETy1z9s6fj2XFuGZXINxrKiDSUEIPf+np5SEAVhsKiPZ/MQC18zv13LXT98q4e37uLAvzgXHV4pWaxUOxVzT5DALiGwF5+3RdI++ZeJgz1IUqXk8j9zbuaEgIiG9h/lC4Mhx4rhABGb27A5+EWUGAFdwHZNfqwbbsmVwXvTccs00+GkbC5ddjtlg0KUa4Dcjo3Rzo4TIgveFg9cAoPsXqMBo0Vju/wgeE1QMzXAZEmj7RU8AS4RrsuJ25OkQz2yUC7Q8FGzAaEgLiDw/pQAMBARpY8gexzXoGVpCNCIc/FGzQmRWEQPhHAQfVAkIoACUhEXoIAE/yev0ANtAw1+A/L24AAAAASUVORK5CYII=", 200, 66},
		["FAMAS"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABPCAYAAACu7Yr+AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAOsSURBVHhe7drdduMgDEXhdN7/nTuVC1muY2P+ZCTY380kqWME6NhJ1rwAAADQ21f4Fxm+f4SH2b5+hIdwiM3LUBOMUQhkXyxmgqdgPGHF8BGQBAKiz3roCMgFwjGGtcD8C/8CJli7MBEQmGMpJAQESCAgMMnKXYSAAAn8inWh9Apm/efKvTi3p2v2uKYE5ELuZlrYxBIyr9E1e1pbPmItJLcxteU2voV6CchiLFyVPblcrNr0zrIBufP3Mt84Hyv1elnfj8FzCy9hZVNKeNnAXHE+tfWerUfL3M/Od6ZljB4+Bs8tvNToiZbysoG59vOpqTl3Pe7EsXPPV1NrT499B+m1wE/wVCt0faST5qgz+kp3p3Zf47zO3t8y59x6Wsbo4c/guUUDTxkdEH7mBRIICJDwDggfr4BP3EGAhPcXIO4gsG7EF/ZtQMKBGRwD1NLX8VwEBMs5BmkvZoGAAAkEBMuKzX8mZoGAwK1Ug++19DUBgSu5oeiNgDS42jTWs59RwYgISIHazWJ96xEQB3psEmtcbnQ4BP/VJEE2SISnWBABudA7GAStjJX12org9v+Xxub0XONjfXfn3h+fU8fx/DVyxjnTY+yetmJqJzMjrQ2qWeN9Lfv3H2u8O/fxeHH1nrNjV7Ytxt0Cr0KrOWrXd19PPMdVjXd/P4rH7+W+dyV8Bwm8NMdZYwupX4Snt47Hlrx3JSYCIpuTEg5z6aqh4cOwgITe34SXhtGqoWc4NNdJ89ze8RHLkdjI3JWes3xAtK6erU2sVZeQ2oQ81hxnBo8HRDZEhKcoFJaP9XvIYwEJ+8rGZmCd7Ng2It5uSx038uw8PTa7tr4cPeo7aq1Xo6Yo1qY5xkyK7yCysFF46S2+tv0x2P5glPX6tKw67xpZAZEFjcJLl3KOmVnr3QO2uGhmrabTCHNrrZoXmFib5hizWf5nXkueaFzCUYaAGKHduK13tlUtGRBpRhGedmO9CTXmPLvlAmKxSbRr4u5Rb6mAWAyHthiOFefeA99BFkA46hGQifHRqt1SAdFsGGvNGOvh7tGGO8hgGg1MOPohIAMRDvtcBGTGze49JwmGkMczrtcobhYybn4rreYpqa9XDccxtea2suUCIrQaKbfG1vH342jNBb8IiJKremvHPp7viTmAgKjzWjd+uVpw780m9dPkvvAz74MIhz8EBEhYMiBcyZHLXaO0fA8hGCg1fUAIBVpMGRBCgV5cNtJZSAgFEEhARHgKAABgyuv1H2iH1SIWqosSAAAAAElFTkSuQmCC", 200, 79},
		["G11K2"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABNAQAAAADLXhZYAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsgHMIb/YUAAAC9SURBVDjL7dSxDsIgEAbgq03KWN+gvkl9FB/B0Y0+Gm8iTq6MTJ6HLQninZF2qDH+C4QPErgAAAvSgA3N6VUUPuJ/X+o9DgAdIzQaxKwmFeLZsNKPx0HzNDmNTU64XKYklfxYwiZlqVcWJ4r/C4kqFieKzUXHzpALiDeRlUsmlDa8agr64yZ7VSOAdrnEaHcQZVcs6LeNIIg3Fiq8imKR/aqoGgb4qBkSy1cinSj9DNFv1ghAe5MEZGnhu3IHhTkOXhGsg/kAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjMyOjI4LTA0OjAwwvWGtAAAAABJRU5ErkJggg==", 200, 77},
		["G36"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA+AQAAAABG6Gk3AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsgMPDDkWYAAAD6SURBVDjL7dI7DsIwDAZgVxkqwdCVLRyBAyD1ZoQbcBOuQBED16jEBTJmiGLcoEp52CAeI//YT01sxwD/vM7iGJAy1KIxZmTFASgrSeMlgSCKEUXvRZkKdJn0segQJSujwSRZGW0qmEpXihmya9KMzDWpdDXEqYsnMTJPvNfSP6a5MXdEUZf8pETO8+d8liSD8S1aXS0ICVqFI0nxOrv2ivuHQCk0d4VrjeUW7DoqSOFGo69lIFn11R7iiU5RiIda4nYGWDJCbbRTEbVMi+A5cbPYQszUecfJ48E9LQMv7n3Rz8WxYiVRosSW/S/FhA9ErK0fRZEAtvBt7vrIXTdSyCbbAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTozMjo0OC0wNDowMASajzMAAAAASUVORK5CYII=", 200, 62},
		["HK416"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABZAQAAAABTGVbVAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsgOhAWeHgAAAESSURBVEjH7dM9soMgEAdwHApLyldyFI4mMylemSOkyzk4CkewpDBuBL8w7p952LwmWzjqb5ZdFxHiG2s0Fol0fxFtobh6MRdyPjoYkBjy273KRVMu7pAS43kWSVvYrTdFY7xk4ZccHR8O0i85hj5jUEjoPkvHiEfy8Gi1K0L0ogAkftUsdyi/nKTp3M4Skozy8FLvOeEg0+wFlnUXQsOJimtimTsk+5P2JxO7bLdNtcMuQmSyxywtI22qyMsAJVyQHsjqZXFQGFhmUCve8KKn84TEKb5rLKYgFkhXkDgGVyWEZYzia6SZRFZK7EBS+iPOc5vyWGl7JKnWdgrOta7IUC1dQcZqMQUJUBwQjVKEFv8Sb3GQYv3EntulAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTozMjo1OC0wNDowMMgwj60AAAAASUVORK5CYII=", 200, 89},
		["K2"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABcAQAAAAAD1MdmAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAshFjvVJdoAAAD9SURBVEjH7dRBboMwEAXQsRyJXb2NlAVH4Sq5QW7QcJMcJcMq2x6BI3iZStVMsE2QMTNp2VSKxF+A4Bns8QgAtmz5lxxV8fmF+dHEkiYV69IqctLEMiMYDmnB+NnLptz4lK/TcZ7fxN3DsRGkDoWY7DYeumHwbj9IEbzEEy1lDBVz57LiGXRwFyph7qd9KwVF+Zr1PBf4o1SxJZUs/rmlC8G4sYJQmq5jKiVW7KhdSq8KJsHrYp7U2m9uSklNbzyVYtOWnz2UMmYot1akV8QMK5TFqhI+H1lclFaQMF4Wp0pFQVFatSrwqcqHKjD1cJXYF+LXP0MKzH83W943D/4ndsCG5+EJAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTozMzoyMi0wNDowMIlHssQAAAAASUVORK5CYII=", 200, 92},
		["L85A2"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABTCAYAAADa+UgeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAPHSURBVHhe7dnbetsgEIXRpO//zm1H39Ag1YwQBwHDv25iE0vmMNtI9heAz37/9UsfA/iAgAAGAgIYvvXv8uR6UR/+8/2XPkSBT3Ma8z6/Mn4XO0hqIaVd6FPgMRefACNCsMPudDev7CBIuise73b4gBDb7iA1Cxy/n+dCsebV87gDGf82O4gsaEybi9Qej3W4DsiRBKVNwCNuA0Io0AI36YCBgAAGAgIYCAhgICAFrN8HvLgb4w5zINwGpGQB5ZhAm7C501ehKxTGp69vR/b77a+Tn461tH857/P22N8mc7BcQGbTqkjiuZdzrrAWrcY+K1kDArKwuEBHrN0OAeEm3SEp3ECbDtp00KaDNh20KcuIUL6NgCyspkBTYSAkZ6fJ8D5YvCsO27W2ngZxBOkzAcFws4ZF8nC6xFoh1fgh6xVoExr7b2LZRdYRB6Nm3a4Bm6EGrn0aQeaBgCwsLqKadbsW4241cB1/IPNAQLA9KyB8zYvtWZsCAcH2UjuI4BILU7CKNCXU6vXYuIZT5819DQHBFFJFOpJkgUsswHAKCLsHcJa8dttJvL2PmoO7Swzva3M3/hFkzl0HpGbS356L3L56W6OgZq16kbl2eQ8iky30aZHa43uZtV81Zh7TqWOtPp1kwHKu3IG3et8g931ztO7bJyX9Df2Kj32jrz2UjP8NMp+njpVMcIvBlbyvpfWE9+hffM6S/objS47tJR5Trpn6fyXjOXXuyQBbDuzJ++boMemt+xgr6a/0p8c48UPm+PE9iCyK0KcoVDOHsnD6EJ1NUeitF7xHgHv0MZzzSX/jfjw5Ds/JXPNLeqaWxXg9V1z0lvh1LfuDNAIyQCj0uMjj4r9DON7jLiCrFI8EQuT2V14rf1cZnxfsIC+Qov5E/pcTEsIxzhQBWWHhQ5E+ZY0t/C91bmkX+hQDTFOYrQrBKsgapf3L6c/duXuNCTZZFy6xJiABCLTpoE2EYyACkuHuE74lzcRBmzAQAQEMBAQwEJAbNZdXXCatj4AABgICGAgIYCAghje/3sWcCEgn3KD7QEAAAwEBDAQEMLgLCDfWaIkdJKEmaNyg+zFNQCgqzIgdpAMu8/xwGRAKFK2wg3RCSH0gIAlyTyT0KTblNiCtPsE1JwdtwkamCsjsRXikRGkTnOMSq5Dm5KBNJ6l2rGW6RWx5c0uRoobUousdpGXYsKfpAtLyU58dBLVc7iASDKFPgWJTFtHTSyPCgB6kDqctrJyQEAz0tFxACATe9KkGpzJ9B+Ea9QcYJCD8kg4YCAiQ9PX1B3Q1EN8v7G4wAAAAAElFTkSuQmCC", 200, 83},
		["M16A4"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA9AQAAAADAfBuZAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsiFhD4dhkAAADkSURBVDjL5dRRDoMgDADQGrfxN47gUbjZ5AZeyaNwBPazuMXQUTYFtTVLtr810SAPK0gV4A+idrltsC9EF9Ii4pjHLcTBeb66F0LJTvNjrqVQ2Ff7omyWKklHJxcPYCVGqLIoXEYvyFj33PAsGvkYfiqek0GcwXudhXSiHJfLzxJWe57Ei5J2mxMXK2QrKnWZseHEkShGqJp4oRWYW72VVIDmwdxjpxpdy1SjglQYlCQWior/SOodiZNgRQVRYm/Lzk3LMkjS7Auy4umXwL4DUSjM9G1vM/5UdABJvChSMjjA9/EEaq+F9JhSmUgAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjM0OjIyLTA0OjAwa5upvQAAAABJRU5ErkJggg==", 200, 61},
		["M16A3"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA9AQAAAADAfBuZAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsiFhD4dhkAAADkSURBVDjL5dRRDoMgDADQGrfxN47gUbjZ5AZeyaNwBPazuMXQUTYFtTVLtr810SAPK0gV4A+idrltsC9EF9Ii4pjHLcTBeb66F0LJTvNjrqVQ2Ff7omyWKklHJxcPYCVGqLIoXEYvyFj33PAsGvkYfiqek0GcwXudhXSiHJfLzxJWe57Ei5J2mxMXK2QrKnWZseHEkShGqJp4oRWYW72VVIDmwdxjpxpdy1SjglQYlCQWior/SOodiZNgRQVRYm/Lzk3LMkjS7Auy4umXwL4DUSjM9G1vM/5UdABJvChSMjjA9/EEaq+F9JhSmUgAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjM0OjIyLTA0OjAwa5upvQAAAABJRU5ErkJggg==", 200, 61},
		["M231"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABLAQAAAAAdB/VFAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsiJjYhRrUAAADjSURBVDjLzdRBCsIwEAXQCQGza46Qo/Ro7dF6A6/QlW4DLhRaMnYiWJD/tYJI/yKLPBoySToi+4/vmQS9EYmqOkBJi2imAhdsVY86QxmXoUHSDUzU6jl8Ja5KA8VSWDla6jhQGTdKp2ueEvUlXJZM9diR6J+E7GBDPWGdm+npfJIBSAY3F8E6j3gq7sdydUzOwuQkbNdMgl4ck8lj4aeTqLTFfmIuGUg3M1EuxXYBxFHxNplQ3+ESrBQo0R5ZRL2KS7LmQqR+WIgEJN5WgyIdldDXty0472Qm4kj7X6QIS5Z95Q73MMOpIjs5fwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6MzQ6MzgtMDQ6MDADQfZtAAAAAElFTkSuQmCC", 200, 75},
		["SCAR-L"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABPAQAAAACGlrdTAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsjCPPsejsAAAD4SURBVEjH7dS7DYMwEAbgs1xQ0qaKM0I28CoZgTIdHikjMAojUCKFcDGYGD/ukIioovyVuU+2TmcLgH+OSsuB6OLvq19JXpLTKlbuh0q/ShMLslIbRmr0eUYiMEgkIWDQm4wAh6V8AlCxjIvoRiC9p0bcI+f5NEoQDSVzeGm2RGXFbmoLCPE3pYgtubxYWa98SsndjJXBo0llelQlJ1BQ0m+LxEpn0jm5MVJMknbdOrnkexZ5aIREGj8KUtRgJ5jKfLrqrRhKNCXu2REyclI4sb2n4iJsh+VOkbZaJnP7CLBi7OgoAV7mcbe7RX4lHSsMZD/qQOCX8waSbLcFo6skFQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6MzU6MDgtMDQ6MDBiDJqwAAAAAElFTkSuQmCC", 200, 79},
		["TAR-21"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABQAQAAAAB0FgcdAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsjFOftJnQAAAFeSURBVEjHxdU9TsUwDADglCCVLQMLW67AyICUq7yRsQdASm/AlbJxjRwhEhLKEGrs9j2atHYlJNDLUFX5mp+6jqvUf7UbCW7tKEgPsgRRoihJEH0gWRRpEAoUYQcAkyjwSzHHUofOUQe8x734WeDrg66f9SRQt/pVu0bq+GiQaCNVhPqdXD6t2UtcxO4liZL/WE6vj6ycx5nrCfa+DGxEkxjrrUS13jVSLlm0k3wsab4NbR7gsr4MXpA8zBOOreDkUAaLKd+z4uJaZFDKMnkH5cmHJhPzsyPREO98dRYwr/PDPS2rUeuT1dESmo4u1p1uYsXAqEsr4Uf63AotASTKbE7W+WI3omiiRSZlYy0ureKC2rRZ3KTqF62lKKaE0AZRJkFyJ4jNunAScG89U0g9ioG3xIsGrpR77OyAK/+OHvfcL2MWy0uilNgDPk7b8qJYUbhmDiRIIg1RfVTXat9wELJzxoLfkgAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6MzU6MjAtMDQ6MDATxtOqAAAAAElFTkSuQmCC", 200, 80},
		["TYPE 88"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA2AQAAAACqu+taAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsjJME0FtgAAADQSURBVDjL7dOxDoIwEAbgO0lkMbq6MfgSDEZeyEcwKbyFj+JkeJRuPoCLQ+kJpYSr5YImLib+E72PHr0mAPxIMuMftqyI2gJs6Nqv9vx1GvIqBY0puaBiUgdCgZxEOY5yZ3XUoEgPwnbonWk7PCakTzvrKvqMy8VLBF23NZ+fDQuwxKiY47lrlLYLA0GbvD9V6u7QXY4F5UqDuJMnRBXf5sTfdYPvSzInWVNJe0wiyc0qQWqQpZgWFcvCSykJxQKzIv4GoqAs9psCshzgn0/yBMJ+ZyBQWuy4AAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTozNTozNi0wNDowMLy85g4AAAAASUVORK5CYII=", 200, 54},
		["AG-3"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABDAQAAAADxVHcoAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwQAADsEBuJFr7QAAAAd0SU1FB+UGDAsjONU1SpcAAADESURBVDjL7dIxDoIwFMbxhwyMRCcHEzxCRwaTejJfRzev1KOwOcqIiaEEagml/UwwjPwnkh8l7StEW+sloJST50IhkcuFjU3NJTF+n1FSKBmUAgrPpAEr+h4meN31JACmhfIibiI7qIh2xCoUu7HbME9/bLbLVCiQAoqzZZL9IekPKffsy8mJAJK14hCXvBVnBuc5ApHv+5X9iX5/R9mwjkt/gTIqpoZSBWJLVhUyGopCIqHkg+iIJITWDF+sAbir2hrrAGfWSXFsi5xuAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTozNTo1Ni0wNDowMHrT74kAAAAASUVORK5CYII=", 200, 67},
		["AK12BR"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABDAQAAAADxVHcoAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAskDLvAKOUAAADvSURBVDjL3dI7DsIwDAZgRx0qYMgRepSKW7G1EgcjiANwBLKxMnaIahKH0EfsUokJ/qGt9CmO4xTgb6JFqdvvJH4q/9qeEHGQ3Z2emDKIxmnWSLlajFjto2AeI0FsohDEZG2lWHGNXajGiK3ZDiwos7F0JzN5eFGsDINR40KTBDF+s+t49u+xhTaKcaGX9LTwyAvI0uAll4akP2e9JdmLosLxOUG8ZVKTdCBLhR0rzv9ZsriZVLK4KCUNYxzdSRIP5cJNyNLyopbE8AL5sOm4JNwa7cK8uX0UCdc1HHxFXtJo2VROEv0QxUpStvD7eQLFotMfBv78XAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6MzY6MTItMDQ6MDDh4X5jAAAAAElFTkSuQmCC", 200, 67},
		["BEOWULF ECR"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABKAQAAAADWWybgAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAskHkh5Wa0AAADeSURBVDjL7dKxEcIwDAVQ5cKdy4wQxqBLwSKMwATgTRgFj5KS0qULsLBl5yCR1HCpgF/Ed3kXW1IM8M8Ppke8Po6YYrkgxvzAMJcBX4n0pkGeIi1K0QXRqTKuJ2ptThXL5fbW6FwcbbWD2XQubMxVvFHkDprUvgTJlRzOggSSQZDUtImS5NYMboXdfFq7LLAUO92d5Td0i4YA/BwnC9TRnn3acCF+WphYVepxXPa2/EDHpHFFLJMSQ+IE6RAU6TGrKFGTlmQUBE6qbHJ9olDlfkVpPxKrSVAAGq2dr8gTcDapYHbIO6IAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjM2OjMwLTA0OjAwNFtoNwAAAABJRU5ErkJggg==", 200, 74},
		["FAL 50.00"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABBAQAAAAC8nNYjAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAskKmnNrRgAAADMSURBVDjL7dIxDoMwDAVQIwZGOnZL79ChW3OzJlIvhtSDkCMwMkRxSQgoxbYESyf+gpIXOdgAcOYPee4TWy5e5eKDMRbnFOfqHsuUgselwW0WUaIYIrlghZzQ40s1ZjfMlRi4CrI2U252PyMXet+0ckhsJYjP11EZpkd4cDK9rfGcxGmYcGdkjG2Fm6Hi4nfo3VZ0mniNb0vFpx/BApWpGLQIgihW4ux1oKLSOl5GxIMg7SXJSCX3O0iiRGmcJFUnyTxbkGSQRMOZvfkCHDp3I4l42bMAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjM2OjQyLTA0OjAwqQFwBwAAAABJRU5ErkJggg==", 200, 65},
		["G3"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABDAQAAAADxVHcoAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAskOJp03FAAAADXSURBVDjL7dKxDsIgEAbgqw6OjU4OJvURGLvVN4PRzVfqo3RztCMmDSggjRz8iSYd+y80+a4U7kq0ZrkIKO3Xc6OQdP+LtCGKS2XTTLNsoeygNFAkEw3ecLnZrDzmTgCsgfIo7zYQbYpSOHDS1i4v/k2Gz21zUUim2O1MRigqzo6L8VNt9zKVxm/2FlGQ3s3biEMmbjOqjThL/h0dCo659H55Xi+SdzQsWvZcwn8itStKZfCLOzqXsLgBMwmpFhVytwKikHRQajU3ih+B0Dt+xxEAnWhNmhdVLYV265e0cgAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6MzY6NTYtMDQ6MDCR5FSKAAAAAElFTkSuQmCC", 200, 67},
		["HENRY 45-70"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAyAQAAAAAxKqlMAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAslDkzVeIgAAADHSURBVDjL5dK9DcIwEAXgM4kwHSOwQiQGyBi0HiETYCMWYCO8ASuEDVymiHJYIgTHuSfoKLjGlj7r+fxD9HdV1szd+jlXzNxOoi3P6i0FI9FQtpn4SXYIyCJRX4Zd2Y1ttbMwl+SEpOf9IY3p63RtvkHg7Cbr6dAWiTkSSDMNkHtlgJwuXpZBMZBe5U2/JBSLnzG+WLtC4ktZbuw2smh2lSidYmdEiSc5u4XENxviMJAkXRwaSYTlHyVA8UhQGOkAxSEp6cf1AMQILl7FZ6npAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTozNzoxNC0wNDowMG3zIGcAAAAASUVORK5CYII=", 200, 50},
		["HK417"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABZAQAAAABTGVbVAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAslGlYPrPUAAAESSURBVEjH7dM9soMgEAdwHApLyldyFI4mMylemSOkyzk4CkewpDBuBL8w7p952LwmWzjqb5ZdFxHiG2s0Fol0fxFtobh6MRdyPjoYkBjy273KRVMu7pAS43kWSVvYrTdFY7xk4ZccHR8O0i85hj5jUEjoPkvHiEfy8Gi1K0L0ogAkftUsdyi/nKTp3M4Skozy8FLvOeEg0+wFlnUXQsOJimtimTsk+5P2JxO7bLdNtcMuQmSyxywtI22qyMsAJVyQHsjqZXFQGFhmUCve8KKn84TEKb5rLKYgFkhXkDgGVyWEZYzia6SZRFZK7EBS+iPOc5vyWGl7JKnWdgrOta7IUC1dQcZqMQUJUBwQjVKEFv8Sb3GQYv3EntulAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTozNzoyNi0wNDowMHTjNq0AAAAASUVORK5CYII=", 200, 89},
		["SCAR-H"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA+AQAAAABG6Gk3AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAslKJ7Y/XUAAADxSURBVDjL1dLBDYMwDAVQRxw4MkI6Q8+V0lEYgQ1gnp46QkZhhBxTCeFCcQETW4VKPdSXQB4myQeAP6hyvsravVIt4rkEVaovRH2biargIg0TROxvzXW8zJlkuComThGDrDxbZF10AOeh2AgdoMakPstDEDMu5lCuqEp3rCeMYQWwbLKmg44xyAKSnN8/FYumX+fPJB6TOpF8+IYFwKWQxNMo9Exj5TQpU6GxtJqc7BwMzfQ03i22krx2vZFuSVaWCFYWF1KZtlrH/ZLRITCkMt0OucpiUjEdPdBsZW5thhgkyRFU0XpAl1fcQRWt55f1BAnf1Ql/lkKWAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTozNzo0MC0wNDowMNFcChAAAAAASUVORK5CYII=", 200, 62},
		["1858 CARBINE"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABHAQAAAABqxTU+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsmBIctwlUAAADISURBVDjL7ZIxDsIwEATPQJEiIikpkIIi/pGSZ5Gn+Qf5QgpKioiKwvIlJsQY+7ZHIttZo/XunU206i+leKDzcshDcmHWbN+HfUiuHEoHpIGk+iIt9KRkEFo38fVBt86XjgblzogrqKJYry1INy4/DZkS2FkOUoCTzSPgp35s0qtk8vGUMVkWec92oEBZaJmYUxaXLmZyS8efia1bQIYaeegIyFNafwEf2RH8lj0i4r947a1HBFimb9YjgiwkzzJJGWRRtOqHNQKIq9nIRrHTVgAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6Mzg6MDQtMDQ6MDBQUnt0AAAAAElFTkSuQmCC", 200, 71},
		["AK105"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABLAQAAAAAdB/VFAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwQAADsEBuJFr7QAAAAd0SU1FB+UGDAsnCnmO3hMAAAFmSURBVDjLjdXBTcQwEAVQW17JFyRfOSBMCRSAFEqhBApAZCUOKYNWUgG0kBtHsieMiDzEGWfjSWaUnUukfbYz/rG1Sl1YrQSmk8T26mZ6bua6oB4EARh48YDVEKlgqS8idSFApAQIBWgikbYliCfycZHQ1crlKipwy+4GJx22P2bxwNcgijDnB+CVl66GgyDMDveklYTNq9eRSTLY9DGf1vIG8dmRz5ylN5KM5yDeue+t9EnuLSPH8VTFa/uJh7eQNBLiFSPHJH/KNWuZFofT+29TngyXp2jool5LwNM7BmznzLK0ZzFU8KUmDTC48iztIppIfucsy51yHT5tGk1FFaLyESA1S78RN0nNCl6JIEhVRrorftqXJ7eaCgjiynjW0q4F87NMCCZirsxWX7Js255KA9M2FjBtY9VMc2fpeKlE8eJqThTLBJejELvWoigxA1UPknhRXJBk/EMTyoiiO0nUo9qrfz1HXvaZ5lvUAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTozOToxMC0wNDowMId1NMcAAAAASUVORK5CYII=", 200, 75},
		["AK12C"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA6CAYAAAD1AhaMAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAL9SURBVHhe7dntdoMgDIDhbvd/z1vjSA/zAAKChvg+fxTbIR+JYPfy5uctnOIBZL5FKA73FY5uyGB9vemgyfn2QUQ/i6W+B9vieZw1f9/h6MbRQKWSQ+Su49lcPTUJ8ueshPu5ntVvEgSHLCYdCdKI5PgjgTJ6LFqDr3T/1rpyUvcYVXeMBHFGgsTyWIwK4lQfR9Udc/GSbjkgrjZjLGYE3irc/YqF8aw+gCRxRShOUVX57AE600mrk+eJzM/IcT4z30LbovXsyyP9u4GQm8Rli3QgrLfTEx3zHvt5OlOX0Pq0nn15pGUDTQZjxXbDLo2p+LjsO4h0IJwCU0iM8ZIOFHz2bDyRUSLbjXDarBRbvfXOiFdpi9Srx+3a9smbXgAkQMLpNJ8A7LxXKl5ntJsEMWjGRHsVx+3tCSINqPneFSy1ZRTpkxylX3qOex0mSDxp24UG8rc9f1eidcpRyqPrr6XtCMWNtgl+HCbIGVcGUW/7923Mta+3/pTcPWDP9J95JRhi4fJwZ+qe2S6srSlB4kCS85Tw8S1Bd/aed7QZtlUnSG3wyPdEKLr1hD6ic4tFcOApqhJEE2Lki6o10sfW/um4tPI8jt40ryC9QWFVHKy5vu0D2tsYIO8z0fsgUBoM+rnl4Mj1IWfft5xSn1vvqUp1wo7PJKUmOp5E+dz6pKb6kDK6H7X3jVkfS/wpbrF04nsC4Gq1bSQw0eLwHWSF5FgR47qG6pd0y0/eu4ONVcmvpp95gadxEfi1K8jMRO9dxXj42Nb8fxBregMTqLF8gtSa/aTurZ8Et+0xCQL0IEGAgqUTxNr2hG2WP49YQXoDF2CLZQSriE1LJ4isDCIUTbDWHpzjYgXZsuQtFDda3l8HWhA8k/RumUhoW3gHAQp4Wk3EKrI+VhCDehML4/GkmuxMsLOS3I8VxDBWkvuRIEABS/gFelcCtlj3YwIu0pIkJIYdbLGMITlsIUEMITnsYUIulNtmkRh2sYLcjOSwjcm5WLyKkBwAAPj0ev0CbZiUtszRlw4AAAAASUVORK5CYII=", 200, 58},
		["AKU12"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABJAQAAAABQz1ROAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsnIKI1F8UAAAEuSURBVDjLndIxUoQwFAbgZCiwo7VwhiO4pYUzuZIHcCTdXsI72FoyHsAjOLGy05QpMnlLIBhC8rO7vAIyfBl4vPyMFesxLnmfyPNCdC2BEPXXSkWk/P2Gu1ym6sarjVJTUhdJs0PaHSJy+faLj8NKiBwjVFDeoByh3O/4Duit9/9Tljso7HqRuahFfuJTLXJR/nycKoj0CcnlR055KwhD8jfL0yB6Kb9QPudcG9Gl8vWfXrOS1yCW3QoyuTTD9rW8B1GZmJBe5YNqS9L7SyI65PqMuIV0KkqTyLzBH8WWUEmmEWGRmYy7qy3pc3GbwtMghA4sktZOX9OZcINk7tAA6ZJjuExEadhBCEhbGtxYTWk8Z6SGb6thbxX8Hw7nxgunEAq1NggC9gLlAcohLk9ZYoAI2JsHGAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6Mzk6MzItMDQ6MDBSzyKTAAAAAElFTkSuQmCC", 200, 73},
		["FAL 50.63 PARA"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA+CAYAAABuk1SaAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJeSURBVHhe7dnhVoQgEIZht/u/52ps8Lgc0AExh9n3+bNhhiDzSdYCAAAAAAAAAAAAAAAAAAAAhPSttOnSSz/D2d/41y/9Eg6UQuF1jb70M5TSAgA9Qj5Z84BE3UEiPQi8rlGYwknFIjc6UuF8Ik9hmTogBCEeT+EQBARueQhLyJd09KsVpRxP9NBGD6/0UDftxs2D281AerCDxJGHQta2Nyij6kKuT0CAA24CQrHDoy0g+wIt7SwUMD7N+isWhQ8PSg/lXqNqmoDAhZHhGG0d2J0h2U++dB3LzblzfJ7U7oXH+VvWLQJTQEbdjNJ1LH2fjS+KUfcZ4zweEPwhHD7d/p90CUWih4BpbE+towLuebo9EYjaOJ8YS6uee4z7DQ9IrZ+rBZD6zfuR49a+Ux9npD/ruaNY54D/tS3KUUFYF6/Uh6eFP5pjTT5+6SMd6+mvJr8OfDC9g1gKIT9HFlxocyrWcc86P9hdfkmXYAhtriIUjsxBaPNUy7mYxxaQngXOgyG8FkpprGcsPyPzFdpEMN07SF48WifTF4rMIc0twnxwzVsB5EW/l4qldI7nQjqaU+7qPFqulfN8Dz9Z0w5SKgDPC9tSsBQoSswBiRwOoKbrHUSCIbTpTms4PM8Fz2oOiPdiIhwYqSkg0cIBnDEHJGI4vM8JzzMFJGIhEQ5YnAZklkJqGecsc8Lz3gKSCkc+k/Ubk5htvPAvbEHV3knuDFHPe1BCuH1q+ivWTKTghDZXeRs4Q8EMxA4ST9gdBBiBp9ZALTsIO8YcWKSBagEhDAAAAAAAAAAAAPBlWX4ARyMkqq+MKikAAAAASUVORK5CYII=", 200, 62},
		["G36K"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABPAQAAAACGlrdTAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsoBvegjvcAAAE+SURBVEjHtdPNbcUgDABgIqpyZARGYZVuAht0pSd1Ed4GVL2gFkGJScKvn5q09SEi+QATxyFkCEaw4Pr3Qu0+ErduJioCFfWJSSxxRcxEQjq9Y3YiMFrcKCGLx4TEhmi1Jo0qk/lYbpMwHHqUJbZRhHUSS6XRNRKTPg0IZHgdRLghwx64+EdiJLaboXZ8HiSIUaOs7/hA2CTTLkM94cuNctQyS6mpa8URvouthae2TJKrq4vw+7o3i1+axbprksDtTAT0OI0fILYVaMV3kPIjSC9hBxrtbZVbJQrmsWhfWPWeuWtyxwXVpFnFV73YisnyRqiqRWxb85T7uRN/yFMn9hDSCdlEd1JmgLhzQk6LjHA5JwETlcX/jQhflbeJJUsg87givO6dn4s+K+ySYKems97ZRGPiESCLQYX8V3wDfcB9zlPIS1IAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjQwOjA2LTA0OjAw/SE/KgAAAABJRU5ErkJggg==", 200, 79},
		["GROZA-1"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABiAQAAAAA9pKG7AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsoFAQZ/78AAAFKSURBVEjH7dTLTcQwEADQMZbI0SWkDU7rEmiBMjggxdIeuEEHbCtG2wAlpIONxCUrTGb9CcGOZgKLIi4wUqxYT07GHtsAfzEaDO0tKc63jhTsQDCClhXcs4KriQXBSGgEK+RMkRsjWVFzmd7qmQg0yuF7nIr2zzETm2Y4Ri5lvLGCvy4wF7SspGhXlW4lOZwvTuEr7khJm4KQPkqVywtUiAZKcZvr8BUvT6PIKDsD+jDKgxglro7xWzqK9AJdKtskj0F8Fe/BZpWDTLas7E0mwyQSB/vMiLuR5lPCcjQqZd1fqUz6XOoBSpGjdMXpDL2LKKqUJvQuVUhkLm06pFHaXLSZpC6lBk4gF8uIXhDDSENJtSD4cZVTgrwMjAhS5JIYIO/dL0QzYkFR/xFBpOME7lghA6l6/liacq99U7jc9ACccENgA/9xRpwAL+mk1wCAh48AAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjQwOjIwLTA0OjAw3NQNbQAAAABJRU5ErkJggg==", 200, 98},
		["GROZA-4"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABiAQAAAAA9pKG7AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsoFAQZ/78AAAFKSURBVEjH7dTLTcQwEADQMZbI0SWkDU7rEmiBMjggxdIeuEEHbCtG2wAlpIONxCUrTGb9CcGOZgKLIi4wUqxYT07GHtsAfzEaDO0tKc63jhTsQDCClhXcs4KriQXBSGgEK+RMkRsjWVFzmd7qmQg0yuF7nIr2zzETm2Y4Ri5lvLGCvy4wF7SspGhXlW4lOZwvTuEr7khJm4KQPkqVywtUiAZKcZvr8BUvT6PIKDsD+jDKgxglro7xWzqK9AJdKtskj0F8Fe/BZpWDTLas7E0mwyQSB/vMiLuR5lPCcjQqZd1fqUz6XOoBSpGjdMXpDL2LKKqUJvQuVUhkLm06pFHaXLSZpC6lBk4gF8uIXhDDSENJtSD4cZVTgrwMjAhS5JIYIO/dL0QzYkFR/xFBpOME7lghA6l6/liacq99U7jc9ACccENgA/9xRpwAL+mk1wCAh48AAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjQwOjIwLTA0OjAw3NQNbQAAAABJRU5ErkJggg==", 200, 98},
		["HK51B"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABcCAYAAAArr/rLAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAOiSURBVHhe7drblpswDEbhTN//ndtoxnSlFAQ+SJbF/m4SsiaJD/qxIfP1AhL5/Vaefvt6K0+bLB2Q0YOBte3rQfTWxK/yGNbW6c/HjRx/OnoN6BH+jNta9Kwmz7Svl9QrSGs4RM97kUdvHYQ5y44u6FVXkP04rNqPvTvzO6KvR9/T87khBv/O4LUYMeAbqza2OurbnTa2jkm0/tdo7bOYHpCVBx7x9YRDTAsIwYCXZVYQQoFZWkMS/ncQYCYCAijcAsL2Ciu6tS+rKe6zvR4BwUxm1yC1hU0QEE1rOIT6xp5i/2wUocEsPeEQXKQjtd6TMwHBI0hQNuUl1fZ3ZlssILL91utvIMrrcizPCQhwQvLBFgtQEBBAQUAABQEBFFyk45GublBtCAhSuxuEM2yxAAUrCFLpXTH2CAjS2UKyr9+W8BAQPEptSLgGARQEBFAQEEAxLCCytxPlEEhh+ApCSJDJkLtYWii4E5bTfs5XmWetVo+YB+TTKoOIH7XFpIky97V9IiAPV1swo8yqhdr+dgek9gtnDQzmhUHjUQ89/XYPyBGPQULMgBxprQeL/oUIyKfWwcE1iwLK7vQ276xCZRIRSdfvIBQzsgv5ryYED1GEDIiQkIhyCEwRNiBABAQEUDQHhO0PnuAwIPwWAfw4XAXuBMRrBbEKq7R//9lXfbJqi5er/uF/TVssr4G2Ksit/V79wLrCXqRbh6MFgXoe7mJVsAot4joMiHam9DiLehaiR3+wrqoVJEMxSfhEOQRUtwPiFQ6v4v1OyZs8v+pb+VNC9UCXhSGPXuEQFOJ4Mn8yrp7zmEWoASMc422hICBtuIvVgYLLL8wEW6weRwU86nu2z7Zo90j7dm7HuCfECuJZZL0FIu8X5RDJTZ9oq3DUFPGdNpx9nlX7R9naLe086wPOEZABrPowAqHoM3WLlSEcq4gc4si4izXACoHkpNFmWkBYPXyxgrSZEpCMkxUxmJws+rkHxDIcFMS/Mp6IvLkGJPuEEdB8uEgfjJDk4hYQ69UjUmFKW0Q5xMJYQR6CwLZJERAmH1ZYQZLLfmPEGgEBFG4BkW2QKIfAEtxXkNEhIXSwNGWLJUUtyiEQ1tRrkJKTrqBwEQpLIS7SS05YURBO2KKsWRmihivS6sYJqM0yg3ZWbJEnnoCsj0EzFiUkBKRNiGsQICoCAigICKAgIICCgAAKAvIA3MFqR0CMUZxrIyAOCMm6mLgJPH88JJw9Xq8/qZ3Iz9XVI9oAAAAASUVORK5CYII=", 200, 92},
		["HONEY BADGER"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABTAQAAAADygnWzAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAspEvRha8sAAAD0SURBVEjH7dRLDoMgEAZgyDRh6RG8SJMeDY/Wo3AEl7QhTJGC4THTqmnSLjoLQ/hk9EeiEP/aV6adkFMazJ1c08CyMn9bZC8pIfhWIN0L2IkLl/MJEJuoYSZXIwNWNW0QbCpFUIiEgOVEWQqiOAqiIDIy0DKxIkhxZPalZipl+W2UL3en3Gb17DpWjUpJTU0votriSkQnkB+qj4iX++W+XXJsfZN10vXoawf1mlW6pO9Fhn3WtZgsppH1HcMsLxdSVDhie2UIh48Rz8kYxVDiOLnwYpfjOH9IRrtkogSiWEHXEVEvxB0QrhuUv8IuEyPckh+rB1sKvu3nrFOMAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo0MToxOC0wNDowMI52L9cAAAAASUVORK5CYII=", 200, 83},
		["JURY"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABFCAYAAAAPdqmYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAHfSURBVHhe7drbcoIwFEBR2///57bpwAyDIDkQMZe1Xry0KiRnj3XqAwAAAAAAAAAAAAAAAAAAAHZ8TZc06OfPdPXf15/pKoVY0IatA1kbPZit9YmuiUBOOhrOK442MfLa0YFoXc7aRNZEICdEBpR65YTyPV2SSRxjEUiAOMYjkEziGFPzn0HWgxv5APaKIPKVWvMaVXtiVwb06oaJI0Yghd0xgGc3TRxxArngUwMnkPsI5IQaBi26ceKI6zmOpPjJ1TRkkc2787jn46pprV6JrGNvip54jRues7lXj3v5GjnPtT6m6OuvH/8Oy2O64/VqdfnEo5v7KXubXOL4I8+997vUaXezSgzOKATSr+yN5Vka9uVarYc//Wx9H215+qrJcsPZthz6dD2ZbtKZp40VyL51CGmttuKY13DrZ7RFIAHrgd9bK2H0QyCZDP2YfN09gzjGJRB4QSAHvHuMbahA0rAn00041PWH9Fcx5JynmOgukMhQH52rQOjiT6w0yLPpLihic6BaeBcpGcPW+YqNpKlADC13qz4QUfBJ1QUiCGpSRSCioFYfC0QUtODWQERBa94eiCho2Vv/USgOWrc7wJF3kTmE+THCoBenAxEBIwgFIgoAAAAAAAAAOvd4/ALqbPBPjRjSZAAAAABJRU5ErkJggg==", 200, 69},
		["K1A"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABQAQAAAAB0FgcdAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAspKtxj01UAAAD+SURBVEjH5dPBDcIgFAbgRzhwZISOwiiu4ATCJo4ibtLEAWzixQP2CUUj1vd70F6M/6Fp+VKg71Gif4uD4sPj3oRWuHmyn0hswHCvd6JYfiQ8ieM2rfhFhb+WPXOSJWck0gGJKZMqUVhMmU0Y3iM51l1r7mc7iLfO6b6pjqldoEbcfdkmapJukiRI7en5WYZ6DpBoKAoKYfEcsXgeRLmEBYVTWM2kVlTx6bAVJXeJOyQki8nnUhab/0Y7l1iuHRTH5b1Z3UIt26vU+BEJI1Hl2BhJdBkUxVRJ0mxIqHykLG4oi0liJxkF0VCoh0LvJJ/tBYU+kgQlItkgoDX9fq5vc8OgTmwHQwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NDE6NDItMDQ6MDBi5n79AAAAAElFTkSuQmCC", 200, 80},
		["KAC SRR"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABFCAYAAAAPdqmYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAKGSURBVHhe7dtbUtwwEIVhcwlkR1kC+2ULrCkkPE1QSqpyeWSrW2rZavv/XpiZ8sht65waoGACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGDFQ/wKh27f4sP/Hr7FhzDCDXVsWZClqxcmd3+094SCVCqFs0VpEzXn1gbCO8m90dwTClJBE1CMS1KUx/gVQpTjWiiIAuW4HgoiRDmuyf3PIMvgan4A20IhbFjtx1GGHb4loK2bQjnsUJAKewSwdmMohy0KUnBU4CjIGCjIihGCpt0cymHLezkC899ihZAF8akbe858huBchelGWYVsGaCWdSVhbF0/vD+dR7KW5liv0jV613wRlpu8dVNbz7O2tsW6aY3lOX5//rm9vPyYnp+e4iv3x7SefzTL6/POPJDzG6RZQ3Jja2fqKc0dZltew/v7x+3t7dcUSpIsj8HYsptVG8Tc5kvWkoamdq5e5nOn2eav/f36uv18fRVdG8ZUFeileShySmuW3p/UzNZDmDfMsjV3mnXrGIyv+bdYrQHwFKAwaxCfZgsbXgvC4/mx8OluA9PmSkgDsLWmJkSa2XrIzZqbSXNNGBsFEdLMifOo/hZr78BQDhyh+/+DHBlsoJWLf5ji0wNHObwgpfBbliOEPYhPgaK7sEgDKQmaNtxpTe371mzNKDnH1vtxDVUFkQZHspY1TahL82nWwjl1+xZrz3KEICfxJcBENlCScJfC2LsglmXIzWq5PvxyVRBCi711KYhlOSgFjlRdkCAX3tZyUAiMpKkgVigFRnVYQSgFPNi1IJQC3nQvCKWAZ13/FotywLvVAGs+RVIR0nsoBs6iuiCUAFegKgilAAAAAAAAAAAAAACc3DT9A+txaENo3WTnAAAAAElFTkSuQmCC", 200, 69},
		["L22"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABxAQAAAAC45tGOAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsqDCVDBWsAAAGDSURBVEjHxdYxUsQgFADQj1vQSasV19hKrrSdjSN0dnoBD2Jhkc5r5Abi2KRgggESAoGf2V3j+ovshJfhw/9LdgE2CasWAxwVMQ6QUhpMpB2iQaU9VQwQXZchyaG2amkAkwaTR8Dk4eLSIEI2EangylV05woegrryG9eFb5sLc9KH/uhhskn8eB46CC+l21TwPO2KUFqXkdn/iQb2oqoVxWvdJn0rokfF1mfbXHS11j3174VaF54KMeCv9GMpw9zuo4Mvv9FZ3KGXXg5CFyK87HkpPJXwmAzC/M1NlJAgETGKmcUV/m0Wncs77Cdpc3mdRc2yG+Q57sfvN5HPScaDHaW5h1Z0EYiNom5JKpDINW1SkeEMOqFWpSJCg4dVK2IgFT6Le24bYb7wfy/8LOkREb8Qk0l3jPCuEOk7u8yTijld8DxprIpZFXuW9Etha9J7sYhIVBgqUAodM3BUCCpwhwocL7sLCalUOYqpC8Rf+IpoRGTxX2YKgSwg/8LmwbDJKvEDIJL2XSwR+mIAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjQyOjEyLTA0OjAwwTHLmgAAAABJRU5ErkJggg==", 200, 113},
		["M4"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABHAQAAAABqxTU+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsqIvmVCKQAAAEaSURBVDjL5dM9bsMgFADgh5DKyBHoETJ2qMTR7Bv0SmwZewWmdomidEsqxy/822BelUrp1Deghz9jHj8G+HcxWFJwyqlsBTGlaivYFQ84hlQ3cnFi4vAKGLraeJR3SlgtfBH+FqdTpyRuEhFFpELOWVzsffORxeVTlhAHUsqyYkeTgvcJhhn+Xia5yLh6YY6bBDvpOyC28qLcc1jLMYnGlXz6xgooKy1i1kdWydjI8jWo5Wqa+1bky5SdrWVv0xuylVz9zBt5Tac+zKyR3RMQ8pzv9Tdr1pMDr+085V5jXPIm+A9iWV+E22dKLPQrkK5iSoAQRYqeSZkoGYKMhAxd8T9yXyQ5BoIY6Id+sNhfi3qoSARKTqTAfXEDHde8F+Se6VsAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjQyOjM0LTA0OjAw4MT53QAAAABJRU5ErkJggg==", 200, 71},
		["M4A1"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABHAQAAAABqxTU+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsqIvmVCKQAAAEaSURBVDjL5dM9bsMgFADgh5DKyBHoETJ2qMTR7Bv0SmwZewWmdomidEsqxy/822BelUrp1Deghz9jHj8G+HcxWFJwyqlsBTGlaivYFQ84hlQ3cnFi4vAKGLraeJR3SlgtfBH+FqdTpyRuEhFFpELOWVzsffORxeVTlhAHUsqyYkeTgvcJhhn+Xia5yLh6YY6bBDvpOyC28qLcc1jLMYnGlXz6xgooKy1i1kdWydjI8jWo5Wqa+1bky5SdrWVv0xuylVz9zBt5Tac+zKyR3RMQ8pzv9Tdr1pMDr+085V5jXPIm+A9iWV+E22dKLPQrkK5iSoAQRYqeSZkoGYKMhAxd8T9yXyQ5BoIY6Id+sNhfi3qoSARKTqTAfXEDHde8F+Se6VsAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjQyOjM0LTA0OjAw4MT53QAAAABJRU5ErkJggg==", 200, 71},
		["MC51SD"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABiAQAAAAA9pKG7AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsrJAntnNAAAAEdSURBVEjH7dU9asMwFAdwuQpoa3sDnaF7QFcJ5CB6kCFXyJarvJIhtyjeujqbBpEX2XGcWHrPpIFCKfmDPeiHrI8n20o988zv50UUDQtJMNwjXyP5vIomuBGziw/IURC3GsR/0ziDEAlSFULDKEUgtdWstEnLNZJYHigqLwr9WQmiNKLgT2WT1632/bSKiqJr70em1jg6rLJ4WebXemdyc3oKUbJcxqpH4tqLF5gST3v82OZiO1kDI93c1rC0ubx26zGMnN8GAwtO0pnXgIKsEN8YSW2HHSuWQnrPOHHUOGp7NozM3lnx3WM4oQlBXqopAV70Y9LvUSjH6fe1+ByfTz8rURIXJLEXibkYsU/V9FIrNoakf4iJAiit/ndOdjbJUthMRQAAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjQzOjM2LTA0OjAwmJmDygAAAABJRU5ErkJggg==", 200, 98},
		["SCAR PDW"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAACRCAYAAACG2fehAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAQfSURBVHhe7dltYps4FAVQt+n+9zKzhdnUTOOkY6WoJS7IAiTA0jk/ypdNQXpXAucCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADQlh83w+omX4YlD4wb/MvNsMoJzIWhRD99HZYkzHUA7RMQSBAQSBAQSBAQSBAQSBAQmlTqp3gBecBPvOc3FYZS/SYgCXONXKrxqafUDNL1X4THhV5iFCrVKSx331el+qLbGeS+Qe+31yhxDpar2e4esSChu0eC1GgTpuWto1GpqZ08c/1Vqh+66MytRX9WoQjCvcXlsPuT1LEc4fthOXWO8bnH60HcDsuwHY/F/XE9LOP22Phz9+L3gpzPbFHkJGc013C0IQagdkCaegcJjRUNu2CTU88gsdDDaKDoGYszRKou4me2mDxBzWLMveia18Dzi3WUqpPcWkvZ/RFL4VNCTh2NPxPWx4bdD/k7CE9rSaGvJSA07WO6uBk2f5naN0VA6FLu+8lpA1LiBQumLKmtyQ/mTj/wrHJD4hGL03q9Xi///vf9cr2+DXv2JyCc1uvr9fL3X/9c3t7LBsQjFk243maQt/f3y8vXl8u3by/D3u3GAYm1fh+aX/s/tu7Eg9A7j1iQICCQICCQICCQcMhL+v0vBluEa310vtr3Q7tmC6tmUZUMSA4Bac99DeX28VTtxe+GY2E9Lj/2hX+mxA/UEC5gWN1Nzfvp0biIjrBXDR3yDnJEw+7VoLTFSzqL9TTYHBaQI6dnyGUGYZHx7JGaScKxIHc9GDYnjx1l9gJqj/BH3LxZa50zFOpRdg3I0Q0tIMv1HI7AIxazeg9HICCQ4BFrkHttNdrlrI7urzPYbQY5c2MvubYz3wflVQ/ImQsqXFswbGZb8x2e02xHr32U6KV4enjUMhAUDkhPDVo7II/asvb/H/TUn3MmH7HWNL7GXCa0VzBsfjK3n/0VeQfRoeXktqU238cfAVk6e+iocpa05ZpZnuV2+5m3JbWKc8l5DUz7EJAnVSukfPZHQIxMxzpL4auDn8wgC5UuYIV4bpsC0lvnlgxH6lyP/p9HxylnssBzO6CngPRWlL0NfnM8YmU4OhzjYg3rY8NuKjGDZCgRkFptVeLapvTSt4+YQR44cziob3VAeuj0WqMzz8MMUpnZ47kJyAyzB8GqgLQ+KgoHken/Tulw1B5MaoW59UEwl0csSBCQkZKjcRiBg2GTJyUgg1LhGHIhGI0QkJuSM8fehLEuASmopWJ95kGjpO4DohCmmZl+6jogJcPRUkEJx29dN0SpgBxdUFvvQyDmddswrYQjenQ/QrCOgGx01oAIRBldN2KJkCjEtuncwdqwCEjbdO6M3MAISNt0bqa5wAhI23TuQuOgCAcAAAAAAAAAAAAAAAAAAAAAAAAAHOpy+R9RuAuvybqHXwAAAABJRU5ErkJggg==", 200, 145},
		["SR-3M"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABSAQAAAAA53qYWAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAssCHR0ZvQAAAFsSURBVEjH7dRLbgMhDABQRyxmyQUqzUUiJTfodbobjobUY3RDT9CRsigLhAs2TIaA26btsl5MPi9mHGwG4D/6cKJ4uj71cIh09QNBWaworpMJ46M7q4HMmOOdrtjICXfRCN4vB1FUI2EnSyNRlLTcgyABTmFQGQuO4yfiJYldSbs9WBzo/GYsoTaHY02/LRLLpr3wi0ntXZPYLJq+ukC5eZU5lgovVM+aBaoguoTPJCZ3BMpqUx6yLGmtYx1HkjnSZpNwF/Nnk2TxJK+3MiFN34LO9mKoQ+6cCmglcu8cVIlcAf2vras84lWsIJoPU56xqZU5sPhNdBHspOQoLkD1OZr+DYva57jFl4lf6UBc5Y225lYMzY4pB5jFbDn1QJCoRjxIObaK24SqPl4fFK7NgUZgl9OJ7UR/IvbPZaG7fV/c3aLKamsnQPtyImn3jYNFRVFCLzMOnu6/kCCIFnN0mcuBRJBklWQy8GV8AJgGgR3685hTAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo0NDowOC0wNDowMKT15A0AAAAASUVORK5CYII=", 200, 82},
		["X95R"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABlAQAAAAAgoZEDAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAssFGB1OrsAAAFPSURBVEjH1dZRboMwDADQZEziZxIXmMSO0a/mWv2oRm6xv11lOUqOkM9Io3gxYUpKbBio6zT/IPFAGGMnCPFfAswfi9whFdgd4lgB8KwMpNR3krcg8EIJQkpbQgyvdJQez2L9mkkuHyYKPkjmAvA5HTGVa4EkDUoLVNibiiczuKf0O+6B0F+c+F1S30wurLipy39DhFC0DHkNbda9WHhe0huYQuyJlUPMQhdiDgqH5CGNU5LjbNC+c1uQ53MpHsU+EeKw+93jKUmXixd+oygw0jGic1EpNwWisvmi8t5N0s0lTmuUcY3IQ67JEFeP2QIWJNSu0aWEiuJosNKK7XIkRYYKldKFHkV5ZeXMSk8IjFJuMmpN8g+XiZhGqhBNS4uigNgcW5yZFoitdjxZxcG5jiZeXgJK+YgVqZfEbZVqn2haJPNjsPjb0gsujPhxfAFdSdBJuovIOgAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NDQ6MjAtMDQ6MDDVP60XAAAAAElFTkSuQmCC", 200, 101},
		["BEOWULF TCR"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABMCAYAAAAoefhQAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAALXSURBVHhe7djdUqQwEIZhHPf+L9IjrXIP9nTVUttKqmIGQjp0yA/vc+IQIWSgPxJmAQAAAAAAAAAAAAAAAAAAAAAAAAAAAABgw4P7ewmf39zHoTx8cx+ra3GNzvx+WgQEzRGQToweECmkve8QFlu8b3i83y/ep1TY9xp/PhHvF/5PI3W+WOk5qg8MdsKbPMI98OP1Y10bf9i2xx8Ty+lX2uO2HOoD/ADwm1wWuTK3m/qS4oC1ol8Lg6/btf1Tbu4vDpBr///tbXl++bu8f3y4VsyAgBiQgLy+/luenl5+PmMeLLGMyMwhl+bP46NM464Vta0tmaRG43Zft2v7pxAQNJdbtFu1Fx7v94n7lPa4LQcBGcjeTY+3RWlbzj4ip0223cc78bEaqX5jpedRH6QZVG25X7qnMeNeafGegYA01nNxYOBfsWYoLMLRP9MZJHXDrZ/imuKyPrcFzfjRjmlAzqQtsN5CQkDGMOQSi+LCWUwDIoUr3GYVpf3XHhfmpC6avaWKFKLlcsa6sLVj898nHoe2n1jcH/pUdJOOFkdoq/BqFZBm7H4McszaeDR9xdb6Q3+avoO0KJLcc+bsl9sXxtUsIFvFJe3CbZoreerLeI7MFhhXk4DUDICVOBCE5JrMA7JX/Hv/71k89tLAjHwNrqboRmkKwxeDHNO6MDTjrqn1dUC+qgHpqRA04dCOW9O36Om6IK3aO0hPRVAzHCW0gUI7VQLSUzg0Rh036jn9Jf1sPK1xRFFAtkLQWzg0Rh476jGbQXosMGYPHDX1UzM3IEfDXRLEHh8ouFftV6zWSooWiE0bkFw8yZEyZUDOnj1KQsYMN4bLzyBAyqUDwvIKe5hBgAQCAiRMvcTYexG2XmKVvHizzOvb1DOIFJ9wm79stQMhisQQM8h8eAcBEnh6GcudRZg5xsBNMpYKCKEYDzfMWBgQAgEAAAAAAAAAAAAAAABcxLJ8AZ3jdsVffx+gAAAAAElFTkSuQmCC", 200, 76},
		["MK11"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA1CAYAAAAEVKRZAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJKSURBVHhe7dpLTsMwFIVhNyNUIRCDjmD/C+qYDcCADdAWauSINA/HduzkXvf/JERbIceNz6kT0Z0BNvRz5R6a3ZV7KEbjfgOr65ZDKgoCeFRbEPvpZLmnQJLqdxBKIpfEe46+KgtCKZAL9yCAR5UF0bB1Q4dqgzR2mUVxZNGwRlUGZuzEtyjJcjnO79QY0tanirD4FkyKuYVf+h6+TydzPL6bw+HFvL0eTNPovHqmIJloKMWaTuez+fz4Mk/Pj2a/fzCN0o2SgmRCQYYul4sN2N+PdlKKQkEgVomSzOWmf8zRCRA+3LNuSfhHIeAxKAi7B/CPHQTwGNyDsINgDf2bYanYQQAPdhDcCP1kX5ITLbuHRUFwIya8Niuawp6CghRWe4Bqxz1IQZRDP5UFscFruZeAIsRfYoWUQOplIQXWT1xBUkMlsSQURL/NC5IrRBQEJaxekBKhSZmzbx65zkGJ94p1Fb9JtyHpci8DKmTfQbYoQeqcfXNdeh6sLc4F8lpUECkBCJlzd67t30/NP2S8EFPjQ4+oSyy74F3u5U2lhLmde64ioF6DkHdDI6UEU2ICHvpeYsacI/38YZ7aBYwNckhY2zHt38aO3xdyPMh3FwWJCXwb7Jjxx7TjQDeVixgb3pSwUhBY6r6suDS4QAy+7g54qCpI7O5hL3Ms9xSIpqYgKeVwD4FkXGIBHioKwu6BrYgvSGw5gJxEFySlHOweyEl0mLYsSOyxKWadKMiEqWNThPuiZrFDykJ4gR5bHMs9BQAAAABAKWN+Ae1aG2fW2ZkKAAAAAElFTkSuQmCC", 200, 53},
		["MSG90"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA3AQAAAABh5zj/AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAssOryjN3QAAAC4SURBVDjL5dO9DcIwEAVgC4qUN4JH8WjxAgzANhnFEgUtZZCNHzlHJBfjK4io4JX3yT93iY35r7hvCgFjWyxK6nKXjMMrYbsg9RDx6+nIEjAsm6HKIlRL2CHQhZNVAdJuuchSlOKdkHFuf5YybK7wAG/i1rkwy7HqdBVeJiWVsb59VeKdO5ya4g1FaslUomhbMh1p47khPFb3aEjHnbnrXfnj+hA0GYwSXaCL/1x6VfQ3R6oczO/nCYf+U0phwYKnAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo0NDo1OC0wNDowMOwV6mkAAAAASUVORK5CYII=", 200, 55},
		["SA58 SPR"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABEAQAAAADsUUeQAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAstDoQM8oAAAADPSURBVDjL7dHBDcMgDAVQR5HKkREYhW26BkgdoFt0jpzaNRghRw4oLiRVBIl/q/ScfwnSE45tiM78ygWKqs6hFevXYyuGcyIUxrIkQkmNWPGOyj9w4h3NfGNReJNV+q3wBIU/wyHxf0m3781AmUehWu7tdrq6dNnV0OygrGiROvPUCkiEEvJUryOSX23I8nSyKL66qt9GHkB0qSbLlOxObOnNTIQkyTKQBeLJxfwNJAQLYxnz6x8UB8UEJLrIKEnvkZSCUPQXGZAkQuLpzCZv+4efZiB/IpoAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjQ1OjE0LTA0OjAwQD3l2QAAAABJRU5ErkJggg==", 200, 68},
		["SCAR SSR"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAtCAYAAADr0SSvAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJXSURBVHhe7drRTsIwFMbxCl6a6Ps/EE/gU+iNicZEBZSztARLGd3Y4JzT/+8GN9lo1/OtZSEAAADo8hvFTZPu4qs7hwNztxP/xJXkwbA6Bov4CqCgiYDkdzOgFjMI0IOAAD1cBqS0pGKZhTGamkEIybzk+oq46YK7x5+3GiB5jCmfnV7j7pOPNw/fI/LjRGlfn6HvT2qOG3vuRI6Pf5piOiCXDBiuz2JIBi2xpCBF3BwlnoLChglnE00xYyrmZ5Du1h7FXUDTukQTCJyzXq/Ddlcm98tlWCzGPfx0/x0EbZJgvLy+hdXqOWw227jXnm5ptBM3q5icQeROZK3N1n19/4SP98/w+PTQzSItkDozFxCLbfZCLnm8/E2QWuuWWKnotLPSTq9avPz7Hmu/I+fhYAbxR8ZYxjW9pn3dPy+UzncoP3fpM00EJO+I0NxeHCuNoQX7p1haO5Da5T0Qpetf2tdn6PuTmuPGntu6f53mrnxdrRadJSYCUiokD2EmIPqZKby8mCwHhGDY4fLOrB0BscNlQEoFqKlfBMQOtYWUF1HerqFFpqVfYmjbcTvqAjJn8YzpW96eKa7PnH3EtI5+zXvLwdNWONrag+vj5+49ppgtcoTOluJgzVEYNeYsnlv1KUdAbFEzg7QQDtgz6Qyi9e5Y258h7fd2jVA22QyideDnCAfaMUlAKC54VSzsMcsHjSEZ2g+Cjlzzj3klFEncBey5XWKNmQWB3MnCrikwrXfd2nBobT/0cFcgteEQBATnNP8dBOjjLiDMCpiS+2I6teQiSDgvhD+elz5qRGg4sgAAAABJRU5ErkJggg==", 200, 45},
		["SKS"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAqAQAAAADerym6AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAstMEVt7ysAAADtSURBVDjLjdI7EoMgEAbgdciMduYGniEn8EopUziDN8lVrDIpcgBLqtSWFIyb5ZWALkn+ghE+gQUF4FOrtFdBixhlSuWEFANwoWcRpXOD6GNS6TGJk7iPTGW1i2hOfH4JMvFV5Zv0I51M51WFwph6M5F/iyqJhkzEfjgInWdubxIzgKGjpQXOzWEr0m5akcBWaLGF2ntDJ9sJFYoPKyMn6siI/VB4VYw8bTvaf2HaiH0TgRF7hRUrKkqb3CaEHUCsnMBHlkzMW+qNuNSmJK0XXZgjOKm8mL3AUBQ38YvoggBXdZCpKCVwBfI5Z70XvVlHK4Q4r+0AAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjQ1OjQ4LTA0OjAwz32ByQAAAABJRU5ErkJggg==", 200, 42},
		["SL-8"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABKAQAAAADWWybgAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsuEFUunCAAAADlSURBVDjL7dIxDsIgFAZgmpqwmNQTyFHwWG5wA4/gVbiBV2gcnJlMB9InD1MK9r3BRKND/4nytcB7VIg1P8z+5dlz0g55qGqRIQ91LWoWU4sekSHF1QJzajEfE4CxwRlvQnrBToCzEmf6eBBbLoRyyitthDiUci62wW9nqTI1VwIn5g2J4QVCqvO7EnI/q/N2tqPkWfpQijNFw/pSrK4uZiGCEnXvYCRFc+L0jRGAKyuD4uTiNSFeYy2KEKtIiX2xEqtUsBT8sUiJXcdzLSRFs4K3RUuL4ihp4j1uBZmj4LITa/4xD4LJxR+d2DT5AAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo0NjoxNi0wNDowMDyVT/MAAAAASUVORK5CYII=", 200, 74},
		["VSS VINTOREZ"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAApCAYAAABwQGa5AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAHwSURBVHhe7dlNkoMgEIbhZO5/wiznFJNk4dgZqHKqtJEGFOz32aRMqQj2J/7cAAAwuYdfODHN5Pc++/yxYe96o4r9W7PsMwFxRisMzdWCQkCMrAVUWzxJvRyPWBbO6FLjGvtKQIKeCrFXBMQhgoE1MSBfnyUA/8QLJwEBFK5vsbi9QsrlA0IIUOKSASEUqEUNCIUG7zYDQjjgnbzq5S0WoGAGcSh+BGtt5BqKY0RAnDgqFFejDhoh0UnRxTFaK8Czxm/tWGDDDFJAClHGSSvI1uOotY1y6uCWnNzSE7e37dx2Svq0FNuV/WnHUKs9obWDNpq8xer5RMqxibBoUrp9rs8Bz8IiDtTta97WBVGy/+WsIPupOUugL0N/Bykp8poIyXWpAemlAEfAWF2T6y/pJUXNjOFDtwE5ogBL25Dtl17v9/R4fE8/z2f4hxCNLnkFtZzkGrcbe9otbSenb0f1aU2NtmHTZAaxFgLQm2GfQbiq4gjDBmTEWcoaambk87h9i5VTdMxWfjULiBSgCItZ9m5n3f+ZCNtY1IDUKEDZhwiLSTnritz1hWUb+KRezSikP7Wv+pZxZeY5h9tnEGAPApLAlds3brESWgRka1wJY38ISAJF65urk28NPCHxy9UzCIWOXC4LZu9MQqC8u91+Afr9G4rV6JcvAAAAAElFTkSuQmCC", 200, 41},
		["AUG HBAR"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABWAQAAAACiT+QAAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsuLpRPgYsAAAEJSURBVEjH7dPRacQwDAZgGcPlpdQLHNwK3eBW6gCl0QZdp4+GLqIR/OhCsGoldxDbUlvKPZX7H/MllqwggHvu+X3IAkfW6y5pwpY4lqjfBJFFLe+FbInqUQw+pPHpdlTIeznzLo3MrIYuFxmTtpaUPMFkSNy11gRhkA/p6uEAg5BTLsrdeGxpe/tEVZBjoFHwzPgCihQ4MT5rstSZ65JFyJAMhswkkjp5q3U4utiI/J8SLHmv4qpgL6UOb/GMHuFEjWRTUm1DZIJeSGRiGCWagqsUeGzFbVKCJvFHOSrir7LPWkekW5Ea2ajaoCKX1oO+897Y6rXYXwRvJ/CdxJuKVWfOBsAr/Pt8AbMi0zIPw0tcAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo0Njo0Ni0wNDowMHR1QZcAAAAASUVORK5CYII=", 200, 86},
		["COLT LMG"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA1CAYAAAAEVKRZAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAALXSURBVHhe7ZvtcuMgDEXTff933q0ykDKscfkQIORz/jR2Elm60jXEM/16PYi/34SXRb6+CS8BXo8Zhhpz9IChfINBFoGR7sn7Y0WvP+EvTGa3QU/Dil6PuKu1iD3jzpVe38qd0RKl/ljQihUkgeFdT8kcVnA/EKMN0DBNmgMm/CHXJT0WLGiFQRZjoekWqOkLBpmMNXMIpaa35ipx5DuleNrc5deTQymexIrv9cTVxq1BSg3YTRyA2HyreVogarQTlwZh6HxgwiAME1jEgjkEHvOCSazcuFlBAC6IKxgrCMANGATgBgwCcAMGAchIn6DxIx1Mkw7rDlhBNiGNF8IhXGBBH1aQxeRNR/8fLBgix51BUpGt1XY1AN70r+FKB6u8Ez2xSbUiW6qtlPOJ+vdQ2zNLHGGQUWEt1GdhOKIOaS5yria3+N1aamKewLuI1uJnoy3u7vq8DItQq6WXmk0ZZJaorfVd5TGq0azadlCjhZd6tz7mFRFTwukt/Hb93flZwpoWYlghHKryNsjKguVakXBqKrOEezqhhcUeetH9U+DMgu6EnElvTaV8RzTapcFsRjTJ6dUo5jBD409AzUKFGcm2MlJTnr9mLE+M6KJN1Fly0tL8E0SjUK2kNNCoRwtLumhjUec0p1Hthw0ymsAsauppzd2bRhr0arKSEf0/T7FagshnI+GUKU5oGpxB02Pe4AnTd0PMsZYwEpczEd76EE4fxX9JXw3YScW1GKSnrpb4kZP0O4HWHozo76pxq4Rb2SC4ptSDVOv4mRH93TSuJFjOiFiR2mulaFwX1sN/FALc4MIgK1cPeBbHG6RnuwNQy2O2WJqrR08sjHwmxxtEc/ABclysIGKSSDgFoIL7gZKtzQzj9G6ZMPFZ0KwBekyCQc7iMT/SAXrAIIvp3ZrBHjDIAGyX/INBAG7AIIth1TkLmqXAb78rMMW50DgFcoNgCAB4AK/XP+0UdL9xVI/FAAAAAElFTkSuQmCC", 200, 53},
		["HK21"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAoAQAAAACTZ4ixAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsvJG2BWdQAAADISURBVDjLtdK7DcMgEAbgQy5cZgFLniELhEhZhE2MlFGyiLus4TSpqaIoQlxkzjaP81VR/gbDZ0AcAFA6yKJs1hlyacasg6IESXDJh/ZJ0mKZJIdKpk16UbQkCvek/n1NgOFfchXlvn1R+XdXYnKj5smPb9s0hcQuU/NbjuLXmjJxotj1hmrxIImbxZsLl7nfe3OGMjouBvptRiYulsIbyySO4OvIhGqBD4RaHL2RqWMSN26yZ1lGlrY85I/SoACggiQgy4mNfAEWIIRVuF1RAgAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NDc6MzYtMDQ6MDCRciOwAAAAAElFTkSuQmCC", 200, 40},
		["L86 LSW"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABIAQAAAACbk4frAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsvNHA2SbAAAAEkSURBVDjLvdO9TsMwEADgc1wRhqpZO0TiNZAY8lqdsDdeo6/RrRuvwAL0AZAIYrGE5cN2fuS/AwWVnhQ5yedLnPMF4K9RTSe8T6SRlNwg9qQoSmBNSE+KJAX+ReqCbKic1mQ5bWO/39ZAAwiciuSjwyho0WcVQ0qwlOWiFsjXOO4zuTs8v7zbOslCzqsfJfmeUAzHse14KJ/2+JgkqIFx08w6FjEIszev7OVtJI+ujlaqTB6cCFQ8bg6Bph6FJXLUXjp8SnLaWd6qWJpZdCIbsGJ3v9PXq6Q/Z6m3mfBB2CkV40VoAELUIvErwMsIC/+paG0XkHsnHE+5CO77rSC7QQpPg9+kUAPXueVdGKQhhfVlkVAMWuAnAUoUJeJICgWwgzPFN7DP/n2eNFI+AAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo0Nzo1Mi0wNDowMKNSDiQAAAAASUVORK5CYII=", 200, 72},
		["M60"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA1AQAAAAAsL5n0AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAswCJIDO6kAAADtSURBVDjL3dO7DcIwEAbgi4JIaToapCwSySswAjOwAN6AlSJR0JGKPhMEyhSRj/icp3NWLETFXyX6rPOdZQMEZPNT2YZIpHzV4nJdIsTnkRWBbR6jJINII5UjZrlCR4SRFPtUUnsETU2LqSMYIJIRSuMVk/oLacJF0/E61epeygxg/15Wu2GZnXferutOCmZ/KwpiR7SVdkHCS8mLQAQr74XUnSi72b3vQOBwG+zweftLqwV9ktjZ8vGqqaF3ul4wF9nJNGtyYSSx8uKE2iwY0fRKrkuBE4lghF4Siskg85ICtUcADl7hEzXwJ/kAZmHbjTrfBHsAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjQ4OjA4LTA0OjAwvskEgwAAAABJRU5ErkJggg==", 200, 53},
		["MG36"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAvAQAAAACOYrgJAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAswJk7VNmYAAAEHSURBVDjLndJBbsMgEAXQsRzJm0gcgSvkBlyhR+gxsqgER/O6l6jXWbGqWCCmgwEHZxhF6pesIF4GbBiAf2d2/U+fpcrKRJephYv5doJYpDw+JKHIsg3ld0H0I4kAagrsc3AXgMg+hyRYmm7/OFK2T3XQLTnhKV2V6qbNIQZZkij4VmYu5bIM3C03PweSMJD8gpIkEm+kGq9eZ+kuaB87eY2rPkm5PxJak5B2S/qoyTLnkdrLPBPX5FIaosqST1ClTdfOsYf85IGKn7qdStcbLtfcdDvJp8TaCFzy2+sIVy5784TcHS+yd4oZSL0/WXxbl/W1L89YvmAoGwiRBeWaVRIlyiTKIH83ZZhUBSjkYgAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NDg6MzgtMDQ6MDAwRgNgAAAAAElFTkSuQmCC", 200, 47},
		["MG3KWS"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAuAQAAAABFPmusAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAswFmgMBsoAAAC3SURBVDjL7dKxDcIwEAXQQylcmg1uBSaAhrGQYJOswAZJRcsIDlVKTJUUyD/nBCGh3IFoEV9y4yef7bOJ/iHykQqgXs5lj5MD0k6TKQEHQ8YkUyQ14kM2mCWZgkkYaj7I0SjIydrK38mXwA2ontMcRullXLN0VbPI85GJ1lNHybe4iHCdD7t96XeHKKK9hJRYoVVE7iQ1nSZn9IaEvKbQpdf/ApdvJBoSvl/j2BJpgi2NIc6Un8kAU4MAm85gzIsAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjQ4OjIyLTA0OjAwWJxcsAAAAABJRU5ErkJggg==", 200, 46},
		["RPK74"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA7CAYAAAA+XsUpAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAKsSURBVHhe7dvtcqMwDIXhtPd/z7tVB88Q18TfsmS/z58sLRgb6QCZ6b4AAAAAQNHX9YlJ/v24/pn19UP2l8/rRxgorkXJdaYQk8VF0UTQ3h0bkJVN6M3JoTkyIIRDj+dwpfqkZD3f16c7smBxbULBidfbbUCAWvLEENdmEZcB4cmxjsdr3zNnk++UHouA+cLdX/rj6UnQ2jtPYy8NSOtigNlCSIYGhIbHLqoDQvPjJMmAEAKcJgThCQHBNLnmk37L7VPrUw/LueLf585PQHCUXCBiBGSC0iKE611btB6n17j2WrsMSFhk7XzluHBMGCNWO+aTp/FXG7U+r2rr4iIgnxZVM2cZJ+z/NGbNeJ88jb/afX25OcbXwuqa7uI5i555vx2YGlyTLETmULOgmjmHccMxqfPUjPdJamwL7uuzOkdLlv8tlhQpCNu/vyhUu//dqDBgX2/NpdUwPU0dK5mznC/slzr3pzHux9ZKncsKWZPl+VmhHpDRRcnNOT5fav/UnGS/8PPUMSVS48KXbPOMNLphSuY74pyt12X0eqGP/zBVgEY/19YBWd3YrU8e2OE2IDQfNKgFxPtrSuv8CbJvbwHx3sR3O60F67h8xeKuDC0qAdnlbt66DgLt15+CtxZTMwS5Oc6cS+v1EZrXCGO4LFhJk1oMCQHxx+V3EGk0cW260RosrLPNHU2aTys0PY3uMdgno1iNCMkZXL5iAVq4k3XgKbI/niAdaPL9EZBFep4+0MMdcABetfbFE2QxniS2cfcapLfReZLYRFEGIiT7oSCDEZK98B3EmN6AYSzuVhOMaHKeJDZQhEkIyR4owEQ9ISEcNlCEyVpCQjjs4Eu6MYTDFgIyGQ3vG8VTknvVIkg2URRFTyEhHHZRGGVxSAgHEJGQiGsTADx6vf4DCX98YOfIrcAAAAAASUVORK5CYII=", 200, 59},
		["RPK12"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABNCAYAAADjJSv1AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAK/SURBVHhe7dntktsgDEDRbN//ndvVDnQoY1PAQgj5nj8bJzbfQiT7AQAAAAAAAAAAAAAAAAAAALDJV/oLuPT7W3r5j69v6eVSv9Lf48lAZumtv++lSxe8tedEVsEhjs8gb15wlgtlp3qOCZABbw6QmiycPB6Wi2i1eo4t+0aAvNBpwbMzQFx9B5GBEOkS2E49Elng/p2YQXKb8/qy6oNaJbnhsNezWOr5sVpgGqTt0t6yD1btD/MzL2Irg8OSahTu6gQwYiT7kEEQ2tOjGAGC0J6eajhiBdDaJVtz8nR3reW6ZstttVXLaNuOCJBWpywG1aveyb4bo6vn873ymby+ukeUn8nrnzcLd8+1lOXUZd9dr6ZeSe7AUyMD0FtnLlPuL8vvff5KWY5XT/rniYx17ovVuKtXMjoZWh3tqTfXJfde1dtTRu2qHG9m+uWZ5Zhv/ZKu2dHRsrQWTbTF55XMb5beMqFeWWvBSOfKz7U726o7y3Xme8s29Dx/pSzDo6u+oo96BjllEqSdIl2GlrpKcExYMmh3O7FMUvmZ9qTd1Tujbuv/aPcFPrzuH4WykFvyPT834/VMA0Rzh19lNjhO6BvGLQmQKDtwlH5g3rYjFosPJ1i+SOujx8rA6DnmzNTfU262sn+wF2oyCRBoe92vWKuNBBP8I0A6kBXeiwBZgCwSR6gAkZ1epEtVq8qFb+Envd7Nnyz00cxAUJ2PCRw0EiQEyPn4DrLQaMaBP+xwE0YXPpnkXGQQoIGdbRJZ5B3IIEZGAwo+ECCTyAjvwCQ/xFErNjKIMY5aZyFAHiIjxMbkKuGoFRMZZBOOWmcgQJSQEWJiUpVx1IqFDLIZRy3f2L0WGFn0ZBDfmJxFeoKE4PCPI9YmBMcZmKSF7rIIwXEOJmqxOkgIjrNwxDJEcAAAAAAAAAAAAAAAAABBfT5/AHJPZJIh+R3DAAAAAElFTkSuQmCC", 200, 77},
		["SCAR HAMR"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABDAQAAAADxVHcoAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsxLLcb7jkAAADkSURBVDjL1dOxEYMwDAVQ5ShIRzYwY6RjlYxAmSr2RlmBLn0m8AahpCA4Bh0G21LgOBp+Y53fAToZAxwhF1eVgVxd1WyQege5syJ5UWOlfShMn6/5vJ+BmCmaA0+SORjXwQNAeGKoFw3pVshr9TPuW5IUtUGot9kG0mo2yyltMOUl8Q9tLooV/8yEaVJW+iVlJaGkRikLTm6x6CXJY6mwt1zSklG9DTPJWluRIhpCwEkVTBQXQvD/krEIPESpY8H7b3eLQDAnuyuDSzWKYiT5K4KU/tYzMs12N1GcdMBJzckZDpIfXlGYqy1fZQcAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjQ5OjQ0LTA0OjAwEuELMwAAAABJRU5ErkJggg==", 200, 67},
		["AUG A3 PARA"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABwCAYAAABbwT+GAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAL5SURBVHhe7drrUqQwEAZQ3fd/513jxtKyhhBygQ6c88dhSoEk/dGZct4AAAAAAAAAAAAAAAAAAAAAAICzvOefEMbfD/nlp/cP+eXpBITL/Q7EK1eF5E/+SSCpYJJ8yIUEJJifwRCSb1fNhS1WMLWFcOW+fLTIYxaQAGoL5OmuCIgt1sWEIzYd5CKCccwV3SPRQS4gHOuYlkpFwEi36iDCwV0MTaVgMMtVHWTYRYWDqHrCNSQgwkF0rSHpCohgsIrWgDR/SBcOnqApIMLBUxxuO8LBalq3V4mAcBs9QdjiqyZQoIOwnBmdYosOAgUCAgW2WNzWiK2YDgIFAgIFtlgPULvVOLq2P88btS5qx75FQC5SWrjRc1xbJHvXPfOeR6kd+xYBmahncUbOc+19bF2z5u9H3u9ItWPfIiAT9SzOyHmuvY9X1+wZwx34kD5JT2GNDAd9Dgfk6U+UGivOke7xWtMEeMJt6y2qEXPbcg+vrts7ljuwxbqZUUUtHP8JSCCt3SMV85f81iGt130CAQmiJxz5JRMIyMO9CqbQfROQwVo6QcvfcI5lA5Kecl/yW0vqCceMsa8+n6MtF5C0gEk+pIPOtW+ZgORcvAzG1vvR6R7xLRGQmoWzuMwQOiCp6JN8uCv/uqBUsL2qEzYgPYW+Qkhsr9YQMiAjFsuCb9M96oULyMjCTudK8iEc1hSQ1You2v1eub16de1o8xNJ6A/pI6UiSPLhVD0BIJZwAZldXGeFZIYZ977yfJzhMR3kp1QUST4cbua5e+hsxz0yIF+2CjlqgXO+5kKY+TSKUqCtY9y7/56565mb39ftOddThAtIpEVrHWNpDLPmrUWkuY4q1BbLghHN0IKc8cS90ozxtJ5ztKhzHo1JKugp5sghEY56JmpHazGfUYRH7k0o2pi0HZEDwnyP/j8I7BEQKBAQKBAQKBAQKBAQKBAQKBCQSVr/f0IsAgIFAgIFAgIFvi+048hnCd+/AgAAAAAAAAAAAAAAAAAAbuXt7R+7JTjeXOuwowAAAABJRU5ErkJggg==", 200, 112},
		["COLT SMG 635"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABfAQAAAACFQLXIAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsyDKdYnTIAAAEPSURBVEjH7dQxTgUhEAbgQQpKLmDCUd7Rlht4JY6CySssLFAbis2Oy9uwgPBTPC0s3lTAl8BkBiA6Q32WMUlfTTSzK5NaDDNHKMxYGIuF4nq5TCQtmkNULcvtCA1FHSLfK+FGViRqJJyOMFtV3T1h4Z7065F8K3VstFgkHKB8+aY4lYDAwv9Y1ixhb9xYPKlWYhYLJF3nLB95+wyn+NsW+yvpxJbu/xDqRELJrRuIuUN0Jy+nRNnIRs+URTQSirxRIy6POiEkEYqv5NqIrcSL+lMqYTgoJBzHkn4KDcQCWZiAMJYNiJjICkSmBg5FTSQA0RPxQMxEHJBU0LEsfyoGioBCFyhHIR5yj6iH/Fa+Ac/P0nd0A28ZAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo1MDoxMi0wNDowMARKxGcAAAAASUVORK5CYII=", 200, 95},
		["FAL PARA SHORTY"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABvAQAAAACBOrJlAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsyIJWA8dEAAAFmSURBVEjH7dS9bsQgDABgIwZG1tvyJqUPVgn6Ztlu7Bu0qW7oSjcGhEt+LjEJrpooww31EikfBscEAP7jEUJ2nDR+8+ppfNiwEcuJQDc8MW5WZkVhu1v0KAoTk2NwCLcVi0sk28980Ti0BdcR81i/zlnCnSrsOumAnFzb72LY2qoyGCN4RNwhUaeK3C2wXxLUK2jHo1dElEQ+itECOz2dKFNsa5ZWzmfNrHLELM0B0bQpAn1doJf0J0nm3pRittygpBYJpQgqgcz2TiQClTegAuRLr3XJdX25aRM2cnO3Wo7F9O0+p5zivstDX6CbZbnvRH8/vba2Lg06s5X8TwSdxl0qJTcnwIURf9/ZLHYRvRKkzenqYoiEtbT3PS/FEon9QCqO5BBBTgSOV209h0qTiKRCAqm6EOVID+LUvkFIKCK+EDmOrAjwYjwnTcdUANJxOfOP8tjS7RNxvjhWgJPEynNVYLX6D3xkqWU5JXkrAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo1MDozMi0wNDowMEZvwxoAAAAASUVORK5CYII=", 200, 111},
		["G36C"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABPAQAAAACGlrdTAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAsyLnI43NYAAAE/SURBVEjHtdPNbcUgDABgIqpyZARGYZVuAht0pUhdhLcBVS+oRVBiksevn5q09SEi+QgGxyFkCEaw4Pr3Qu0xEms3ExWBivrEJJa4ImYiIe3eMTsRGC1ulJDFY0JiQ7R6J40qk3lbbpcwbHqUJbZRhHUSS6XRdyQmfRoQyPA6iHBDhiNw8Y/ESGw1Q+34PEgQo0bZzvhA2CTTIUM94cuNcq9lllJT14oj/BBbC09tmSRXVxfht21tFr80i3XXJIHbmQjocRo/QGwr0IrvIOVHkF7CCjTadZO1EgXzWLQvrDpn7prccUE1aTbxVS+2YrK8aapqEfupecr93Ek+2yZPndi7kE7ILrqTMgPEnRNyWmSEyzkJmKgs/m9E+Kq8TSxZApnHFeF17/xc9FlhlwTbNZ31zi4aE48AWQwq5L/iG9ztfs6R9k33AAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo1MDo0Ni0wNDowMLjl7hAAAAAASUVORK5CYII=", 200, 79},
		["K7"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABQAQAAAAB0FgcdAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAszDL5DrHMAAADdSURBVEjH7dIxEoMgEAXQZSgsadN5jXReJcdIR47GUbhBLJ2RYWMSRER+Rk1SJb/B8Y2wu0L0pagWSd2FB2EyaaLY9eKQaCjsofBlqzDztfekh3UugqesFcXzdFHqLXKEwmzKUu2TYj4nz+msFZ9Mcqy6yqZ1f2MICSXSphK2llDEUsb7p7nVQLxtytI480rSqlUXd4PCJx26zuRR9ewGuqmffiZ17NQOcyiJXIqbZp5Ji0TZsC52k6GFevGNiEKZjGmweCR6jzh4DpT73yiLhEJnKAco9JcfE0/v5Qaf8cH3XJcVvAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NTE6MTItMDQ6MDDriK9ZAAAAAElFTkSuQmCC", 200, 80},
		["KRINKOV"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABLAQAAAAAdB/VFAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAszHKP0vBcAAAF2SURBVDjLndJBSsUwEAbgCRWyeTBbF2Ku4AGEehSP4AHEFlz0GF4lN/AK2bm0rl7FkrFN0jZpZ3jiwONBv06S+RuAP5aVoHKS6B5uwv+hFwe4F4Ro5MVQrK6Qmrb6KKTJhAohSZQoKIr5h5SrkefHmeuWnSY2nQ5vL2KIr1EUoedM9JLElZu5hq6CHA4drgNaZpwo3KB2k/IbpLzKPHu1JoZby6CnHzwWMrW8kn/CWbb023AH+oqV6cm0oL/Dz1x0G1qC6L1MLTP7a/0eL+8qcXXyp52kFqAfwC4XnD50WJy+3r67/Gagji2KnFelpBnUHLBeMktiV6lKiZtWSdpMbBIbks0k7bnIdqPRpbnmt0uBTCBdgaIW6Q+CQRpWIMggSJ1HelFMmMvkke6EBME8nr3YvcT8NBNC5WOuzKjPSY7HDqWIOXYsYo4dq2EOt4rjpRbFiKuhKJoJLkUhnlqJAmIG0IySGFFwkESLUvWSKCcJPMCl+gWOPiVUknZh/wAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NTE6MjgtMDQ6MDDBd/f0AAAAAElFTkSuQmCC", 200, 75},
		["KRISS VECTOR"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABiAQAAAAA9pKG7AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAszKIJASKIAAAFWSURBVEjH3dPBbYQwEAXQQRx8pATayM0VpQY7SiHpImdvBSkgF0dpgNxYyfHEMAbb4FlBtKcdIS3iLbY1fwB41Oqf3z+XyxWCWfkcBCuKFSxKV59m0vxD2ruKOCO0lha481mk7Tzt9mtKCb+O5KplsU9VXh3JSPKTBHMRNRlIrox0YV/FidmJnWcnvIOMfCR4mQ6FVpm5F3jZdBStjKJTuBBF01htRa0CvLR5apMoWtVHgYrM4XlWXCaextHdkA6XSEi+oox7iWFHGWrSMzKQ2CTf4yKSEUtisk+Xl4FOben71luBkCwjvYGy1au0Y7OTeE6/CSGJfNtJPOfctaq0WMYzTVO840WW8UzTFKvfyrqnKOMBtf6rKRsaJiTdhwVT26BjpSiJcFoUL/68oDstTd62g9LmDT0oIpv3o9LdEHNa+ODuHCkbj+SFDU6w0nDxADzBw9YfD3HE9uBsB/gAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjUxOjQwLTA0OjAwNPewFAAAAABJRU5ErkJggg==", 200, 98},
		["L2A3"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA3AQAAAABh5zj/AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAszOnH5OeoAAAFBSURBVDjLrdNLbsMgEAbgQURlU8lZZlVfIScoV+lJAgfIYXqBShykC/cEddVFiWTZxY9hZohZtSwsm8+GfyYEYH8YT/dP80XjUxtIbFXcssiuzCs/ZOlosWmRdtpGZCLHkIXm3j5duo47so66TH8SV92nKoqn5pW2d9ts3TF7O7OlOi12pp71yxsDB7POr0W9c2nShN/KHQ/FLhEbEbk4yigllTJuv3r6+vUgvgjWo5wfeY/79dykMzWNRy6pggHj304nJh50RPm6nklSLNNjYSG8kMwzAWOCDVnmDrY+CxsXAIwGdiwFJ9xQiIo10T2miVyeU7QOpediKZq6EwvYtk6Iz9EKab0asgQpOZreTgNKMLiGKiX/wQtpOpufXSEXnpPLBzWrEWK+qVkahPyI8rjI8oT4iugJ/lFUrAnUQv8CvfBa0ZuQtFUAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjUxOjU4LTA0OjAwy7L+7QAAAABJRU5ErkJggg==", 200, 55},
		["M3A1"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAADQAQAAAABqphPFAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs0HOy1KtAAAAFBSURBVFjD7dOxccMwDAVQ6FiwVJku8iYazRzEl6zhwgU3yAIuNII6s2DEkJJMgRJQ6GKfC+N35jviIBAGkEgkkjdI4zlpB/pchxhHSf1y0U8XbfZLzd+xWYItxeUvDV0pfpHy0nwWtpcwhB5BxYoqxLMysIKL7hS3jOUB0u+R+XsO63niGZBltuPEr6B4+VlJflP9DS2GD5PlCxr6DfSpaPvfUv2yd3xuri3kCube3NBgUSfIbXuNdwpLT0k3DkYX1fwkqQuzkXjapYpx8Fiuk+i0Loq4Yys7PhaWuFjHRfxWlFlLnA6MDcO62iQ9fDISqnmPy2pxsW7TYqitdPflw3JJK0dJPYql5MyJPqd/CSkuidknfdo3SlTHCdgkQAk8XAZGFCvL77VA6zhpDpwo4ARERETeVYCXowOJRCJ5bv4AK54HWso3zLkAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjUyOjI4LTA0OjAwKkBM9wAAAABJRU5ErkJggg==", 200, 208},
		["MAC10"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAADKAQAAAADI6zI4AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs0LiRie1AAAAF9SURBVFjD7dVBboUgEAbgISzYlW0XTb1GF0281tvhDXqkehSbXoCkG5rncx4KVhTGNJbapnWWfoDDrwGAzIUNAQKREIloAHgXS4muqkjUBkFKGFayh7CD1gs0/YI6GOxG8RYajrM9iUkA7senHGsovBgWpiNsViUpyomYi7Ti+xSa6awSJmM7YKEs6gtieCQ2IUqadeEpMaS0WQXx2VBip1HS7SiMkjYtbUbpv7dIyZCopAVfYjFOLoQUqcaaDVJnnVOHh1i82ppcSDGxaC8qLQpN/KqTF2BuwY5r3/DDKP4wtaLOw9FwO8mw306a8m06NJxIL/J1EveZuBfgS2FOdChqIbAQoKVvuxMzKccoIpFjfJF8TO3FgIikGNLZJjdpsemnBW36d4QAPKbFpnlKC1azm2CSM+JTk5T38Y+OxMjU5T4IpKrcIGonwX2EZRX+i0X8G5Hr0n6/FFmF3s8Qgk5K/ycc8uMiDjnkkEMO+bOyei+YPYSRHViDT9YVp23awZUXf5UAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjUyOjQ2LTA0OjAwvBA+LQAAAABJRU5ErkJggg==", 200, 202},
		["MP10"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABVAQAAAAAk25auAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs1Ni4V0kcAAAFjSURBVEjHndJNSsUwEAfwhIDdiN0KCnHrKbr2Ft4kAa/hYeJN4gleH24qlIz5ejh9yb9SZ1HS/pp2MjNCdMNYfvfO1icuktj65JgosuwtJHyd7h5enoFMFMP3JMfc/EdSje98ZTLSJpgYJAM1Qv3A4pGsAe6hVZDX6dgtCXI6ZTh1xI5pjz4mw4xELW3ZIiBJNbBy7Xwti9jIIpmEjQgmhp+0EerKZFkCS+luEW0HCpeubuWD4lVdqs8lt7AVF2X9Hbi5pJnEKyI2o75InF6a63Bl+YqiS0EF1VGOcnY3skx8DqJwmfizvRJ7mdIrYfP7ae+AeHcr6083Me6Ic48C7Hm970qs0ROS3LaOTPQWH9PSk3Rkc0jMjojDUjprViRTTwIQ+acEJLoVlcfxmMgq1EjNauzIAEVWsaIfWIZ/iQOidsQfFrkjMxCxIwsSg2VFMmEJSDQWOi4jFpjbAKujXF38ALjenoTEbcIaAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo1Mzo1NC0wNDowMAjnRKQAAAAASUVORK5CYII=", 200, 85},
		["MP40"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABnAQAAAABtaTAIAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs2BiPhsSgAAAD+SURBVEjH7dIxDoIwFAbgR0hkMXZ1MOIxHEw8ildwdDApiZdw4DAcwDvIEToyNDyB1lJefUYS4yJ/wlC+FtofAKZM+VWi4kPZeFL6kFSeKHcX+7TTYwVHI6kn7fREwcnIHklq2BqRVBB2RvA7sjbbDzfwUhSI8imxD01lImuOSEW3Y2GvgXSFzcCsG4grWdBdjZc7KxdPssFJM9nLsDcIRKKWXV2oiKSYNz0ddCgC85V5bChXVvKleWEZyM1KQaT53yoiC/e/KUZqOw5E6kDmtp1QbLBiJHIHpBK7z0IleSMFIwKz0ZIicGvq8ZKwEmtO4MwKTPKXUo5fM+WjPADCP4hxeOA95QAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NTQ6MDYtMDQ6MDA1RECQAAAAAElFTkSuQmCC", 200, 103},
		["MP5"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABgAQAAAABwbACwAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs1AOGvR94AAAE6SURBVEjHvdRRUsQgDADQdHAW//j1j2v4JVfZm5STeBV7EzlCHX/YmVrEFmgKxHWxs/ljXrMJTboAh4UwlMiRFIsO/BUd1E5mUpxuEIATKb7UeTn0qGvlYryPz58OSe92QYv9i7hCHsgcoUPPRQeh81wmL2stlsl8zitvRIo7XN5+msx7822H+2Ritxl15RDi9PI34MWUEiZu8mnHlY4iIwxpM0IdgWrvJc6hIowUuCYmiaTFUr+WpHNfml3qYoF94A6QaGaQiE0umgGWKd20RazmGgmPdbgbB67xB5oe8Qt7imu+C7GuUlUGf1dCAH6TqRR5RdRNopZ/saOkX0RWZe2DlLkUt4ioyUzlqJnKWZ8WlQ4YKbAIr8kTmfNI5sB9RRPCmmQ4ULoGgbuJOVL6FhlvF0XKC/wjvgERAVecaAJD1AAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NTM6MDAtMDQ6MDC0SG7TAAAAAElFTkSuQmCC", 200, 96},
		["MP5K"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAACdAQAAAADZYAp3AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs1DgYXatkAAAG5SURBVEjH5dbLbcQgEABQEAduoYFo3UIqCC2lA1wapSClAY57QCZgbPPxjMOSVQ7JHFa23w6MGRYtIc8LaTBRI2LDB50xASdLckfFYRWMiF/nUZ8+xFFmLIt555vYcrg/xZxqE4BIi0iMUNb0qCx/TPA3tYisK/o0wefxcXP8ExlZHfNzCc1XsIRbCYvOontlPQTSF87zxPv5LPGwEeuvfmoknhk8bmlQGCiuEobmlEmNCFQ4KmxAaI+4XmGgaEzWKGRJr7cL7xUBikuyn/TilPO9bP1ZBCxpPkBuoMgrWXB5BUVtwlIhtThc3rcO1isa+3/LUuSgEh/cX7aLuRwtPrAiS51j+YyIYbqUYjRDLJKjydt+cZKt/EpYt/COHO73S0iORTeliDFZDrGlTFfiYJGHyFVy5yqJB4LQpLrPV3TfOqqVI3w6WM9Cs+QqO8SAwrKIR0SDwnuE+3yAVdvgWnwjRTFdwvLgjRBcpuMlaCPsaAr1xV/iGMoWoqvhDCZlMfuyP0ksLGpM7o+KvBKHygLL1LShR8QvCW83QoewMUFWh6Kdo9hgQZAmBLGoIIMRgg1GyAf5/fgCTKSXqrZFckIAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjUzOjE0LTA0OjAwjK1KXgAAAABJRU5ErkJggg==", 200, 157},
		["MP5SD"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABFCAYAAAAPdqmYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAALLSURBVHhe7drRduMgDEXRpP//z21ocZZLsSwM1BI6+2XimdSNQRdhZ54P4AafL/nl4/mSX5rzkf8EbrMPizUE5ESavE3+KwTCFqviLAyWtwRelGNsdUyZ6MJZODbRQjK6oGvjbHFM2WJdYHEiZ6oVcxQEBKLI4UhCrISaSU5dQVsMLe+FXhrX/NKM5QNCIfthMSBLb7EIB3pxDwIIlt1i0T3QK2353gGpFZTFPaEWAcEI3wHQFJOnsBAOjKIOSGItJAQBs3GTDgiavvC60kFY5eEZ3wgDArZYgICAAAICAgiaHvNaU3towD0VRmr6L975pWkEBKOkmld1EC/hSAiIXxbr7DQgnsKRRAzINkezr31GLew/84zz9yIgC/A2R56IT7EYeEQndhCvAdlfj+Yajq7fC6/z5IH4FCvKwBMQHOGLwhcKDEcOAxKtaAgJauggO4QEJQICCAiIYXS0+1WfYkWdmJ6nWduYlec4G8vt/eXPl8dntvdjLDrIAEfFeVa02uLHfQhIdmexlkHaH5f/hv9FQF5YyXEkfEB6w1Gu8NoVf/u9V3++1HsdqPsTkKsT5NGIopLOMeL8uBdbrAFSEJJ8OHyRibRoWfPnMW+UySivu9U2Tj3naRlrze9pOR903pMcaXA1xSapjVXrOVvHW3v+1vNC9r3FYlD7pTFM8uGh/DbG24lwE9W60pfuLG7NZyd8Y3GT3sBD8fUuAPgtVEAoHrSigyhZ6B4eOthqwgQkUvegU45DBwEEoVr21ZXV2tZGex1syfqF6iAUDFqFLRjvqzBd5H+EvQdJhZPkQ6Aq/E16zglBQRVPsTJvIdF+Xu1WDHUEZCcVXZIP3YUG41EAznGzPhcdBBCwqiyALjIPHQQQsKIsgi4yBx0kGG2Q8IOALILOMAcBAQQEZCF0kfEISDCEqA2DtaDajTjBuIZBW9A+IASjx+PxBX8dWKWZezkLAAAAAElFTkSuQmCC", 200, 69},
		["MP7"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABqAQAAAADR9yPWAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs1KNQa7yQAAAEESURBVEjH7dZNCoJAFAfwMSFbBG5bBF6hAwReqZ2bwLmXmzlIlDfQaFGBzWtGTGd0npX2Tf+N8n6Mg2+eICH9wourXQcbLjdpTdxyzZZp4G14EK2SIFoncFBh4EOVTN9FCUcFWAeJbxKrIW5sEtkFj3cQMKWLyJb6ZhFmFrnK56YePFbkoV4XvTuAyqkpdChKGZFPCzXZF7JU1hBN5qqI45UyzmWqi4OKeKUdHVVSzbAlZVKWasIwOdIZIkAXJiHFdBqFKaUWUb7JsIPAM8QrJP1Kie8QFxUHlXx2hbCmNPN+CVHxgWLCyW8J/MVrEfqx4qLT+ypxtD8TXdI3i50RTCjplzOdInePlUD+eQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NTM6NDAtMDQ6MDAwAmApAAAAAElFTkSuQmCC", 200, 106},
		["P90"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABPCAYAAACu7Yr+AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAANwSURBVHhe7dlpctswDIZhJxfoj9z/RDlADtOMG9MjuooWiAtAEdT7zHQk1S3NBZ9lmTcAAABoe5uOGMS/h+n09vYwnQ5lPsY5i/ESkAGFAiIcOt6nI4ANBGQg4dM1iOfPv0QVAjIwQlKPgAACAoIhWN0t+RVrEEcFEn7lif8m5Tzaez3lPNp7PZ6HY7g+Ev+fJLWtVARkECnF48FegaeOj4BgZZRwaNAOCM8gGIr2hwUBcY67hy0CAggICIajeVclII7x9coeAYEr9/v99vf7+3lsgYDAlRCOz8+v57EFAgJXwjbHx8ef57EFNgodK3kGkTbSPDzThC7eH3/eH8M4Cok01lQExDHtgOzxEJwtBOTCSotWo2jmeg4PAbmwksLUDoekh+C4DkjuBJYMtodFypU6zpKxlcyhptbroTHezQZaDwSwoBGQ1c+8hAP471dACAfwGxuFgICAAIJXQPh6BaxxBwEEBAQQEBBAQEAwLI3n6tdOIw/pwHr3nTsIMLO8URAQQEBAgIX5XYSAAAICAggICCAgIICAgAAL870QNgpPsNyMkpy5Llv99FYnOXO9hYA0UrtQLdcnpa9e6qV23gmIodrFWWqxRjl99lAztWvAM4iBsCjBdKnGos0avfXHAgFRZl00lu1b990jAgIICIiiVp/APX3Sh74E02VXNPr1asDDA1fvWhaKxXpp9F+jX1I/ctuvHRN3EIc0irBXRwVdW/C5CAhUtS5giUZfCIgzlneP0PbS9NJlERBHzijYkvfs6S5Si4Aosixgy7YtjBISAuKAt3AEHvu8hYAo0yyM0FYwXeIEr4CM9L3xbBpFfcVg9FiDqw5dcWEs5Sx6i7mf9yfn/VqMI/U9UtvP6fMesYHSgaJPy4LJWd+cYiutm9T3SG0/p897qhvwoHTBRrJVLCXzclR0NXN91HaU+h6p7UkuEZC5mgX0aq9QSudiq73aed3r49kuF5CodkG9kAqvpzkgIB0bNSxHRUdAjhGQmZGCQjh0sFE4ExYqmC7dGmEMvSAgG54peZguXfHa714xmYk8fP3KCUcv4+k90AQkU69ByS20HsbRezgCAlKol6CUFtmZ/fcQjIiAKDir2LyFw1MwIgKioFXBaRVY64B4DEZEQJRYFJ1VYbUKiOdgRATkoixDMkIwAACocbv9AIlr5+Mqx2ZqAAAAAElFTkSuQmCC", 200, 79},
		["PP-19 BIZON"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABfAQAAAACFQLXIAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs2IPHsNNUAAAE2SURBVEjH7dQ9boMwFAdwWwxs5QhW1Utko0fJQaI4W44VblJLrTJVDVKHMpD86y/wB35ptw7lDRD5B8/28yOMrbHG30VFi7K3h4KgNzexFI5BX59F+rQLI7jF0iCKRAQpLSUcv5NzYWk6Tuk7Qca2OSKSOk52AdQsyGIWSQiWoYhxK6XhF0hC0M25rnHVlD8+s7es0nbESJ9vdJJlCbyMpZ0GsfW88FR27qh7gY8g9hT2zDWLwHtBGr2+skiYhG9LqUz7CZz5V7ICaRqqM/LKPzPh9ofAlj8lstfzKyvt7TET2AK1etZZBiu1q7kR5g6GeQEOdj6TYev7xdfS13QMzbfz4jLIIcjGjfgeRiQ+pyJlat8+l830/SyE/SyKkOqOdITUd+RAZqOEk9mYpN4p/dmt8W/iG6rsCwXglC+BAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo1NDozMi0wNDowME+EY2AAAAAASUVORK5CYII=", 200, 95},
		["PPSH-41"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABTAQAAAADygnWzAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs2LhZUGdIAAADISURBVEjH7dNBCoMwEAXQrxZcqrjpouBNmqPF3ixH8QguAxWnYks0Jh8qhVKo35V5MYwzChz5jySWSfa2nKlcqFzjUshNDJDLK4so8UNl/Ew0k0SYZBvpXV8Kt+a9fi5ogt1zIqc8s+y/S+cNQ5hoKl61XEwotk6ruJg6LaceRQRMRlSzhBUMqNq4WJTThYj0U486IjghKq+VcAbKEHFzDMSdrrcCJstHoa0vHRUwWd0pXwyTdTmK/u5q2C/Nt2Tc/0zR4sgv5QHuVmIYIzHKHgAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NTQ6NDYtMDQ6MDCxDk5qAAAAAElFTkSuQmCC", 200, 83},
		["TOMMY GUN"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABdAQAAAADIiBTDAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs2OgyOza8AAAEtSURBVEjH7dNLbsMgEAbgQV6wqcoRfBSOFo7m3sRH8KpiQZmOef5+IEVZe6RERl/M/B4coqeeeqdmdvL9fSOWl93rckJZD+JGortwr79dlgqKz7UNxdeOH8ibfST/NMjmqddYdNvJQo886oFApDlHwDs2k+WHuQXLj1mFQGwWSTHz9iXiDrck0XvzLrak0hx3UU3qoyyaf42IbvIq4oqYmsAUCHKVZOZIKDFdSTZp6w/iSpKLeGryqmMz9bBIdlRJVpQ01iAfL+JAQjo8fyO+STjJmsZ3JwuIZQKhJjKDCBJRTAAJKBply6/clkShrFnWJK0M15PaE6LoEk2O8CplY3uVspqvUqaur+L6Cl5pkUgjwf/RC2TCn50E2tC09GuFbQ6l/Ehoo6ee+qT+AZtE+Y+dwoTCAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo1NDo1OC0wNDowMC2bNakAAAAASUVORK5CYII=", 200, 93},
		["UMP45"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABrCAYAAAAy0M3eAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAARXSURBVHhe7dzdctMwEIZhQ3rEDNz/FcENcCkMpWWgdNM1JMJay/q1pPc5SSxSW17piy23wwLA752+AsN6eaVvvd690rd33usrgA0EBHjlu8oQEAwt5PbKwhoks5AB8d3vIr/QgLAGKUwGQuimKfRzaI+AZMCEHxcBSSDBELqJAXEvHCFHKFiHlHd0nLbGhEE6IEcwjloHbT22uy2kzd2W17Ut97aQNmvbJf+ub6uw+uKz1ceqne5ZTMHxT82AxI4VAQlEGOrKGZ7UsXP7QkAchGNuBMSDYEAQEAfBwC03IFP/HoRwYM+UVxCCAZ+pb7EIBvZMFxBCgSOmCAihQKzNgDChgDduQN4TDsCPP3cHDAQEMBAQwGD+Df8td/HiYi2DEbjzPFtAfPb27+43tD9ACe58bHqL5XZGSJvQTaCpZgHZCwEhwRmwSAcMBAQwFA0IC2707tRXEFmHrLQJqKroY15r37n3l1NM31y1+toDt55nrc3WuBMQFdOfUCX73YqvXnKusbVM+dmj5Fj69q+tY3ezSN86oRykKEI3i9BDVBn41lLOs2aNQo9VLCA5JrTsY6VNWUhxVtqEyYTOqVNeQa6JeKWb2WgmqodCT6fIFRBxQudBsTXI3n7d/YX246ij/S6p1Dm2cKa6llQkIK0nwlkHr3VdcjtrnXPqZpEeQgZM6CZuDJbNarJfQWp/S/YUiJTayHmuP3/0nJ+ef758+/Z9+fTxw/Lw8KCt6Y72o0ddXkFkYFbadHop4Uj1+Phj+fL56/Lrd7MudCv4CnLLNzFLT4KeAuFKqc163us+Yurw9PT8crlclssl33diTD96ExUQcVuc2H2EGGUQUmq0VeujdUk5vs/RPvQo+utECr7Spqyk+EI3u1aqRqFaH79np1qDaCautGl6bi3W7dBJTzjSRN9i5eJOgBGl1NhXn3Wfe/UL+dz6maP2jj2CZlcQKa7QzWHFTr49Wr7kcMBWNSDXEVXaBAN1aq/KLdbMA12jvpaQ2sf2cYZxLRaQGYq3J6W2NevXSz9byHqLJcVaaRM6wHj5XQsT8w1CUW0p38qidn1j+zv6PGCSF5ISkBaTjoBsO9UvCtGflC+CHhCQAkafNDMhICcz+i1LbwgIrgjmNgKSWcrtFZP0fAhIZkzysRCQAmYLycgPJQhIIRISoZtd6K2/NRCQwq4pUdqEjhCQijQn3qCMfKvSKwLSgObkSptwUgwQ7sRexUYNO1cQZDHq7SEBwR1u++4REMBAQAADAQEMBAQwEBBkM+KTLAKC//Ak6x8CAhgICGAgIICBgCCr0RbqBAQwEBBs4knWGwICGAgIYCAggIGAILuRnmQREHixUCcggImAAAYCAhgICIoYZaFOQAADAYFp9idZBAQwEBDAQEBQzAgLdQICGAgIYCAg2DXzkywCgqJ6X4cQEMBAQFBcz1cRAgIYCAhg4L92QbCQW6XRnngREARzAzLz418Ay7L8ATcsH3B4JOmPAAAAAElFTkSuQmCC", 200, 107},
		["UZI"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABtAQAAAADM8hNuAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs3FidNkA0AAAE2SURBVEjH7dWxbcQgFABQLAq6sEAUVrgyHStlgEhGuoUyAqMwAiUF4YcE8AHm34XIiVLcL2zLz8Zf/I8hhAhHkJAekxXKFbWX42fAJtxfjjEWANWICJjISnQr8B1R10RCilpoHI3CFqaRPt6SsBmxvyHrXsDlIsyIp+DHkuYJleUHQlFhqPA5SX2HzsGcpC4bSeoygYocJYwVzhGsPKqRMmi1MtONEBMJT+S5XqX50Zh8eByJY2MxbCw0ls8MhbnUqXsRNstDL1JjArnvA1OdhLIizroTX8ToUysuy7slL63YLP6Vm1ZMEbn9ZrLoInz7zfRC2sglpCP5Oi2ojN4JN2SUgUfFoWJQ0UfK+p9F3RA6IzLJkru4ljJLOxHliZ3wcgZsk6aAbewMFXqo/NV37nKvz2HyAUl4egJz5EBTAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo1NToyMi0wNDowMGzsCMAAAAAASUVORK5CYII=", 200, 109},
		["X95 SMG"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABcAQAAAAAD1MdmAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs3JO+awY0AAAD2SURBVEjH7dNNDoIwEAXgVzHpkgsY8SAm9SgewaU7egO9kb2BV+gRWLIgVIqpSpkRMfEv8W1o+DJMMkyBH88iHCaxbMJBxlJyIqqLaE5S/WjNTZ9IkiKcVCTyKWmHMIU+RJK7S0xo7eLY8JmehI7pK2Wfv6fPk+LqIZEfk7Bf/J/jJRkUA8WIRtY+AdsTPyf/lpBapn4L16ysKOncHdGpASlZnewoQSPiSEgzX+X0nJDKi6Gk8JerW4OrVFgyUkYCzDHLz7JFL17cPSlZKRixjAhnhWXE8JKY8SJ50eMlxWjxy8BITQvaZSBFuZIROn/5BlEWr8wJxlGEzT/BHb0AAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE1OjU1OjM2LTA0OjAwVAksTQAAAABJRU5ErkJggg==", 200, 92},
		["93R"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAACAAQAAAABmKBsyAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4ZCj6AB4UAAAGZSURBVEjH7dZBboQgFAZgjAuX3KBeo4tm7LG6MIG5mUehN2DRBUmpVHkIyOOZjDGTLsrKmU9G/wePDGP/w49moqRVpGjqY+/WESe2Loogxe2li/LtynGX+ZRirL/QVEWTYg6F/WF5NClRnVBQWtoT0p2QHgsjJcwZSBGU1Iojqcc4dqFsTcJJwXmypqhOQKuQt+w+qsw7Fr4SktfFznAx5eJLamZ4F4VEjzAbixohGiFLpb6QTB9QKVOX7oQshbJYRpAZ1WB6C8XFcsMCtZ5ewlLJUhRnqHCwcppLEI2kW27mP7tAIGY9cXu7CxR2iFxuvmlREf3KmH0f8tfOtqJe16GUT9hSTR4IxO9vuS5r2iN+y9v0VEVIk0X1Oz7lyy4LESmQ2LfAMFPSO0p4ClQ0VJcCFQ3VputCUqCmbMKYAEkMFLZOkhioLSUGQsL3B2xarhQISQyEJAbi2YkWXttQws32kqVsfzGwpGCu6MFYjLNinySmJuJSGY5FP0nUCZFkUnalzJdKdbF9nrpwUtihVJfUnwdnRD8kv1s4uvt0LhtJAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxODoyNToxMC0wNDowMBvra/cAAAAASUVORK5CYII=", 200, 128},
		["ARM PISTOL"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABKAQAAAADWWybgAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4ZGiM3F+EAAAEeSURBVDjLvdSxboMwEADQc12VpRJrNz7F/ZT8Rwb8WR09RB3TTyhShiyR4jFDFMdn7IDxHVIo6kmA5Mdx+GwA+EPUvOjpyCsr76W8pecLAOfjAvCRSeOG+GIlxm25qHXEmSAtIT/+uJLiFov7J2mLEeHOlFjwYvPuHAc5ZWJlh+mdH9rusvWxfQtRpMlzUM4vGxQoZR9E5KJxb+1hM+zEVAdQvuFztJ8fIlDMIFUPfu2lvxxGIn+ThHtGEiJIHctN5BpkmhGlwdMkRBAVe1xKG5pGCVUmiaZFsCLLyUSp0tfxhNTERHtpWFH4ryDk5ltgF0j3jMCcOP/WnEhWQLEiDC0ayOClXSZmPVFz0q0nzZxoTi7ACZMCNZcCFZFyB6Q/kgfmrn3+AAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxODoyNToyNi0wNDowMPa0WS4AAAAASUVORK5CYII=", 200, 74},
		["GLOCK 18"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAACAAQAAAABmKBsyAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4ZKOvgRmEAAAFESURBVEjH7dRBbsQgDAVQUBYscwSOwtFI1YM1N2mOkOVUYnChCSqR/cuQSKNZ1IuRhqcEYhsrpZRXKGjiayH/aEG2tZH2WPLzJW7pjyUpwgmJSVyn0L88Tf6uj+8UqhvpBQWfGudAQ5Ff93PpLJRRknznlJFkzTJIMivxcF/by7jE38svLqtD5qbttFxSqm6ipIliV1FyPhYk44OiKzGdEpHcuQwtCXwfc0E8+9K9Q6KfgJBjuS799pHEifKZhERJlfNHcaw3r4hvyTuXUjckYduvPrUuGxg6JK0SFkN1yR6VvXBLj4zVlT2GPSGuJRMXD5/BQkg0lDKpJigwbRFK4DLCktqWrDBtgnhYUizULxrKcELMBZlRqoWSFoGpjlBCjzhY0qasXPx5WXqk2QbzKwqeBnjq4Ok2wHmk6S1vpoSwSo5v3ccbsT/UDdUAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE4OjI1OjQwLTA0OjAwUwtlkwAAAABJRU5ErkJggg==", 200, 128},
		["MICRO UZI"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAC6AQAAAADDyT/5AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4ZNP/hGi4AAAFeSURBVFjD7dVLboMwEAbgQV546SP4Gt35Sl12ERXvei0fBakX8JIFYmrAIX7MVBWioLT8iiJHX1CGcTwA7BszZB9vAMItyxYzCd9Tflki2kJMP68EoisEF5GIXS4NDoyIKArR/1RkFF2JokWwoggR8w3rQkLpa2wi/fS2pktkSGHKeJcqW2TZlz8kN1aQF8uK21XCdrIyXvKNDJt2QZFi40jipCUE6BPkZRwBsoDHUGvI35hjWCkKT6cQK3ndYyqalazufLCn0mdiWJGs3Kv7COPxhRIvOelEx4msxURxlagNoo8VwUvHScOL5wR6Rvz0BCalh3dGRjCWlvCMs/BGigtNeKXkMxQNnqw6lDbdLCFt+Os5UrSF8CJ3oTg+Sd/Ko/DomykvWaXOUaJYkaeL2lXO7/UWMadLe5DgM0rzlLKpB22c8XUMK5qV5dQ7oCIuueSSfyYNK9NQsvBr+QIE167ZG9gfHAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTg6MjU6NTItMDQ6MDAIPnQkAAAAAElFTkSuQmCC", 200, 186},
		["MP1911"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAEeAQAAAADnM2e1AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4aBPIVeUEAAAIGSURBVFjD7dUxUoQwFAZgMpmRLXQ4Ap21laU5gNfwHsTKA3gXbdN5Bgtn6GzpzIwMcXeBEEL+JWZZwB1TwX77wgt55EXR/1huMG7cqNwU2V1nSgkoVYCo54ftxfX77ceLKjebS0OUkhFVeghTeqNokkZCHFJnQSeSci/xlHKHhCgsT0CoeoPyCWf7gjEKSAzlgiG5TKHAmCv4nOQb5vaIxFk6jWRQ0pmEIXFuQ4kmq6uXQXEttD4GBr/qk2IgLQy+uO4AyKDYxVMa51Gbz0Da6URmS7tUkdqStOtIbImhtC+bx1bWeq3RQNq0m2A/aRbUTOsnbEz4UNJTiCD9OhiIIyaHUgSIJOrVLdvtJO63s48CkkdAqnoTuS38vqglt6TSG29I1pUZlt1l4S3SJcbrwsIOigyQ0ltKhxBD0t42+IvyEGpIclh4X6SPiFZiL4lDJR+XpP56RoSGii6e9Eghh0UXHFNdQiESeUp2AhHdjYeoY4V5CRkT7iOlU1JD6EAklJAY0ZfmLjFOCmKLLrdmFzrhWuK+GAcfNSU220JfjHOvnk0nJGwx/9oXGSDFkpKsQ/KpJJ005gQiTi9s7cKXlGxOiZYUNaNU6xQyp5RLCp1e5F+T4Ba80uY8a0PPz0fW3JxX0ur5+ciaW/Ccrf63TZNBoVB2QUAolG0QEur+GHfjJlrl+AG2dIyb2puaPwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTg6MjY6MDQtMDQ6MDDIOfR5AAAAAElFTkSuQmCC", 200, 286},
		["SKORPION"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAB/AQAAAACC7LD+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4aDhLAkF8AAAGESURBVEjH7dVRasMwDABQGcP8V1+g1DvIWK7SgxTsjx3MsAPsCv7of/M1AvOSxXFiN7UUlsBYGdNf8+pYUSwF4O+Faijpug+bf4n8P92lcHPpijARWCnjKl5KS0pHS9xIoGIJsaxeFImI48uiNsjKfQQlsUCKlOrXBc+txeVyFsT7ucQaMFKQFCaRK+RtlCIFkPiacAWVmhRDydAGqHhSGlLctajbbVDxM9E3OWe5KUAWvkpq6XARzSACkbZKvf35/K6y8JjkIP4ADyH9JGki+T3wLGysRXhS/wRgdJpfOk6rcKqaXmwWFWekGuVYJRlDLsseEzHK46LYUg6U+F0vCl3Ty7GQITdBCjeDuFKYBVvIUJ1+DFuJCzAjY4/kCLU+9ykCKi8AO1w4wCk82Fx0OOjhokhfniy+vxOg0kxlmsvUaeEw+e9LjQpLwtK3DxF6zSw3fi0OF5hOPCKeEj1/cSKLAkrgJ0XesaiN0vwLIdXGuzlUQnMYSl4pMXy18IU1cJ/xBSDWuLxeWRzfAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxODoyNjoxNC0wNDowMAST9OcAAAAASUVORK5CYII=", 200, 127},
		["TEC-9"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAACnAQAAAAB8gS68AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4aIiAY/LwAAAGSSURBVFjD7dVNTsQgFABgGkxwx9aVXMPFJFzFI7h0NXTn0iN4lRovgjdoVzaRgIX+UXivabsyWhaTlq/v0cdjZgjZNO5QuaLikns9XhRbhFb+sway8SDK+VEvJNz24C8LV47JXDtLMowPxKSAxQLSWIGIvvLGyE5YnumtcV44vE5XmkCkJNJhQepPiUUFa6nvQiafVnwYBYk2/L2VkHw7+RXOAbLOTqH6wqrnXMx0giUqAhWOCjsgFJX0XLcESxdJUquOJNSq2/4JE0Ffa7dRIk3W19oJh6UcJF6mf7nyaYjNZYgpYwm7QAYhuTwEsYBcELHkPogBRJS5sDDDNCa0zmWYaVG5zUUMM7nIVbFRLNztpbj9UqxLBb0bRYWNTRZpfyaRabd5LDYTAmUTo9DX/v9pIeFR9pIcxCk93y5qLJAzTEgq87dmsxTrUkNCj4qGhK1LBQk/IGL+FdgnBBJ5UCwoalXMTnGr0h6QeqcoVDi6jt9sRLqdw4Qojck4Tvlnok85hZ/y26VG5RGWG0IQWY4fZTuuM3mGXsYAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE4OjI2OjM0LTA0OjAwRrbzmgAAAABJRU5ErkJggg==", 200, 167},
		["M79 THUMPER"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA4AQAAAACQsYoqAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4aMNOhjfQAAADaSURBVDjL5dNBDoIwEAXQQo2wMOECRq7g0oWxV+EILt3J0Zp4kSZegGUTm47TVlCHzsa40p8AzTxIBzII8TdRYFgZWHGseFaAlhZ4yH0QTaQFzCEIbSEAnIPQjZTUQkYZH8KVDddNOCVJPVxx4aiEz1DAe5I4VoAXfKVlXrC7Ki/YbZMXzwqIcTGTXgAjRnIyVJz4lpNZfF7cYw6+I/YDGajYNCnraUbHnHaptKJyO6o+lhpN5NJxIjlxZVenDeppjuMtypbbZ+lVWiMZaXQx/2OjVDgJJis/kjv6aRuZ/gDI+gAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTg6MjY6NDgtMDQ6MDCL05D3AAAAAElFTkSuQmCC", 200, 56},
		["OBREZ"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABWAQAAAACiT+QAAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4bBOsOSAAAAADqSURBVEjH7ZMxEoIwEEU3UlDG1oZ4EEeuwhEsrZSbeBU6jyEzXoAyBcOaLBAgyzaWyi+2yJv9+7OZAGz6a2UKm3ViEFt2mBtXNGKn7XSGJVWnpy+B7BFfOFfwO2CscpoqkPwLcpeIYmDMlorEiIQHsNKYkaQiMSLht8GaQMJBK5l1Q2beMqwmEYasmIWXlhbDzEareAEdTNLrDSGATedx5y9QJ7FXvzR7K9QibyDVuScLMyCTjMiyxZMGsosnFSMV6Kviv4YS6ZNiLS5B48hD8Y9Gf0rzKe6w7ZdnYwC7Iy38DYIK2LTpd/QBTWwB/KG9jJEAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE4OjI3OjA0LTA0OjAwJ/ufRwAAAABJRU5ErkJggg==", 200, 86},
		["SAIGA-12U"] = {"iVBORw0KGgoAAAANSUhEUgAAAG8AAAAwAQAAAAA3ZhnvAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwQAADsEBuJFr7QAAAAd0SU1FB+UGDA4bEPHUnH0AAACmSURBVCjPtdJNCsIwEAXgCVGyUTxCr9Ab5ChewRu0Cw9W6kH0BlYFyUJ8Tdo0zsQfEPTtvhCaN0OJ/heDjqhMLBCzQ+1ZIaXxxCcqSS1pGPEl9XtmD9VDDQu0G3/swkT2ugQOaUB7ngteZnvO03bN6RYF59GtwrpiqoY48UQzNnhB5Ztm1DlvE3XOcOPOqSVV2NLjUzTsJY4QqqTLY7NOUv4fJf0+PUTA6EtS5FyxAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxODoyNzoxNi0wNDowMHzOjvAAAAAASUVORK5CYII=", 111, 48},
		["SAWED OFF"] = {"iVBORw0KGgoAAAANSUhEUgAAAIgAAAAxCAYAAAABf+HvAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAFdSURBVHhe7dnRjoMgEEBR2v//51YaSFAHRDNWmLnnpa7pg+PcsMluAAAAAAAAABDCK32i4bNIly68FumSQGq8RSGJobgOhAjqchvv309AoTw43J0gnBqyMoqSm0AIo81tIISxVguhZuhAWsttDeoxirOL7/V4IB6XeeSuZV/x1wfxEMNIy9WgPozFCKwt/YzLg1s+Dcog8pxeIzkc2nIIpRxAnHcbg3TPi+rQ8aWkSxOkpcdP6X7PPS/EP7XHF5IuTfC6XA3ii7MSyFEYec7W93q+Y9lu6PxCZte70J55vcYRmQzE80K18e9+NJkLhNND1xS/Ysqlt56POPQNHUhr4dJzEoi+IQM5u+j8zASib6hAWPB4Vgt5Ig6iGNtjgRDGHP4eCGHMZbesuyIhjDndHghhzO22QAjDBvVACMMWtUAIwyZxqWciIQzbLgdCGD4cLnkbC2EAAAAAeFAIX2s7tDCAwqpiAAAAAElFTkSuQmCC", 136, 49},
		["SERBU SHOTGUN"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABcAQAAAAAD1MdmAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4bKNnWJOMAAAEQSURBVEjH7dRBboMwEAXQsZDiTSRvu4jkK2TZHVfKDczRWPYYlnoBpEhJF8gTjIEWPL8EJWq76GyfzLcHj4nWynCqDwTcLkDxoqallrMK8pJJDBQnCEcoGImF4pAoRqKhyDEBxgQYE2BMI7fmZ0U/VYqnioJCq9JfMJPudZfghz8XyH2dgqKHXlqyXpYTmVqU0JCuZPGk5/P0oOxkuZxE6TZ9PdJ+NtKTnF/okEvs9fsbvc6/Vg+zqFJvc2m7XfhcdHwxDFMuRniGkthFxj1S8jz9UxyU7jj1RlFQCihxSPxGiWNaiWLHJzOT8jtpZXG/LlILpjU1lAoKbZVSaNuaGOE44x1tkEj1L39BqKwI1w0tw3g0mxJIHAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTg6Mjc6NDAtMDQ6MDBX/rWuAAAAAElFTkSuQmCC", 200, 92},
		["SFG 50"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABXAQAAAABpEzelAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4bNM3XeKwAAAEvSURBVEjH7dS9bUMhEABgEAUlI3iFbOBVvEcU8aQUKTNCViETZILIdGlfFySTdz5+/MLjuMKW0iS5Bskf3JkDnhB/NlTgREdWlhskZZMwt79JgKmKhdAJuCwatqJQfK4DA1njF0jqgY8mmslS+XRp/iSp5MZgX8221zmKjKKVfeDEbq7E6fjwsQqwa6APz8r8AjCWS8axOFb81XL/zsrX9dk4ObX7iUIfv3vQdmcW+jmNb6Rv+DqeyHFmwTfzWMZO8PDMK44LETzwnS8zOnFJbHfLsmBh4+xyOPSS0qNEKqFeIiplazCQqVzr5a6XsgtZT7+VUkYNpJTR5GXY2kbdrUCpUw15NxfZsWv2rNj1LKn0dURNAtynVQL3oVasaAg3yMyIYmXd1+Bve/EfPxpnZnVOM7n7MuEAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE4OjI3OjUyLTA0OjAwDMukGQAAAABJRU5ErkJggg==", 200, 87},
		["DEAGLE 44"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAB3AQAAAABuvzKTAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4cAk0se/IAAAEMSURBVEjH7dS9DsIgEABgSAfGvoCxr+HGazmYUOPga52Tr9GtK4kLQ9NTi9UWuDZUYmL0lv58KZS7A8Z+KlakyNJ5kUEvlSPFU4xExLCgDWOf+evGCyvZhRSMF55U2KdELZAF84RWqmckixLbMiJKYLEw6UtJ/Rv4CR01+HCadtz3A2lGMhxMk1KRAiNZ95UzAt1dmT8+yNCBfqnAW1fscDXwxhNlhe3Ccg6JJKVL0LGakE1YDpqSvaHkRAq0lFSKEi1LQpq83IYFMZDRvkl8kdNSk3K7QlD8St9DLRCclCZOeFLp+trEiUgqub+t35AiqUj/YJkVlVQwvcBfYvM2UzkdJ3Tv5KQIUr4vrg6EyVrAcJ+DAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxODoyODowMi0wNDowMLUg8fAAAAAASUVORK5CYII=", 200, 119},
		["DEAGLE 50"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAB3AQAAAABuvzKTAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4cAk0se/IAAAEMSURBVEjH7dS9DsIgEABgSAfGvoCxr+HGazmYUOPga52Tr9GtK4kLQ9NTi9UWuDZUYmL0lv58KZS7A8Z+KlakyNJ5kUEvlSPFU4xExLCgDWOf+evGCyvZhRSMF55U2KdELZAF84RWqmckixLbMiJKYLEw6UtJ/Rv4CR01+HCadtz3A2lGMhxMk1KRAiNZ95UzAt1dmT8+yNCBfqnAW1fscDXwxhNlhe3Ccg6JJKVL0LGakE1YDpqSvaHkRAq0lFSKEi1LQpq83IYFMZDRvkl8kdNSk3K7QlD8St9DLRCclCZOeFLp+trEiUgqub+t35AiqUj/YJkVlVQwvcBfYvM2UzkdJ3Tv5KQIUr4vrg6EyVrAcJ+DAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxODoyODowMi0wNDowMLUg8fAAAAAASUVORK5CYII=", 200, 119},
		["FIVE SEVEN"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAC1AQAAAAAyn40sAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4cCkP388AAAAFjSURBVFjD7dXNjYQgFAfwZzxwpIFJaGNPSytbyGSkk22FUijBowcCKx8bRR6OEpyT/4OT+MsA4nsIcOfOnZ38+OsDEe2vfMygM/5nMLnYIFblIoJkf+qD2KLQXEgQYsN8dh3hZ8Oi/ZglIUWhTYWhYpoL/5AMzUQ3FbMtjGOCl46bp6FMpUIsi4LWgq9N7gocF/3i7Dc2fRLhhHphCRhQXw8gscM3u7I6SdZJTie+PF6XHkFxuInNd4dE4nCjE54eW1HofJelEp5IeZGQL8ELxUWeFulFHJRhEYYKUbuSnrT2rcxvgCcQd1T2U0m6uTO+E4lVqtyn5YXJCE+gBhPrVq8TWRfPdFDopjtQ2XyIFhlT+C9s8QRARUMejqzqmIyIDNWiToltKV1T6etFnpFYVKJCoI1QrDovEHaB6FPCq6WmsTCpb6y2oj4k5RWU9+3c+3lXB9g8pLQ016dYsd25c0H+AKwJoC7PJdjmAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxODoyODoxMC0wNDowMO4V4EcAAAAASUVORK5CYII=", 200, 181},
		["GLOCK 17"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAACAAQAAAABmKBsyAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4cGl5A46QAAAFCSURBVEjH7dRLbsMgEAZgLC9YcgSOwtFw1YPVN6mP4GUqESjURsWZ+YvBUpRFZxHJfLIh80AIIaxAESa65tLPwMi2psIeS3o/xy0+6MCF6xAfxTRK+Jenyd/1sY0SykZ6QcGnxjkYofCf+xk6DUVxkmZOSE5WgY4wb4P8GF/bx6j43+Fnl8Uhc9N2WioxVTdW4o2iV1ZSPhYk6qQMhchG8UjuVMaaOLqPvCCW/NO9Q7ydgARDcp377SOKYeUzSmAlVs4exZDevCK2Ju9Uct2QuG2/8tRD3kCGQ9IKITEWQ3ZW9sItLaKg6GKYz4rpENshAckAJd9UExSYNg/FUVGwpLomK0wbIxYWDktolwHK2CHygswo1UxJs8BUeyiuRQwsaVVWKrZflhaptsH8ioJvA3y3KCgjap3Y8W9pM8GEFnx8A843HBPLRfCUAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxODoyODoyNi0wNDowMANK0p4AAAAASUVORK5CYII=", 200, 128},
		["GB-22"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAB+CAYAAABhy172AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAMgSURBVHhe7dndTuMwEAZQ2Pd/5128SqUKlaFJ/Df2OTeUCyCx/XnG5gMAAAAAAAAAAAAAGOTz+DrM3y/Hx/8+vxwft/MYizIG38dlJjvN0ZAXfZ78K4M98+KhrtFhnHInEACejQzJ8AryrAyEcPDdsgGx2KllVEia/FHBoLb0AREKWkoXEIGo6+wC2G38UwREKNoRkHHK2JfxfDUHf46vvzIhrCpa228HBHYkIBAQEDi8arUEBAICMonooPjKqxsX6hMQCAgIBAQEAm8HRM/LjlQQOLwqAgIyETdZ4/w0lqcG+OwEct7ZRb/jnJwdoztOVZCeDwav9F6DWiwInE6jNmussoPuOge9q0ehgiRjg+pLQEhhRPUoLv9ROxk9jArGgwrCtEaHoxj+AJGsVapM7M4V9vn9r4xF+Znj43BTB+Th7ACP9pjgbM9910wLu5ZUL5Rpwe0WkhXDUaQ6g6w6CZmVOSmOb5eT7pC+8mRks8NcpH7BmduXx+J55xmvLrR33//q78c173B3Fm/52eL4lgZSByT74ujx/NnHaLT0FWTWBfBu+1ODELSjxRqk16LuGdQVCUhDqkh+6QNih6QlFQQCAtLQT22PdiiP9AHJuNi0hXmoIA3NEgSBvE5AICAgjTlv5CYgjfVsb4SxvvQB0V/TkgoySO9g20iuERAICMhGVJHzBAQC6W89dtoVyy3V3fd103VO6sHaKRy1CMg5WqyNCMd5Kkgjz4txhucUjmsEpJHfFmTvZxeQa9IO2szhKCzINTiDQEBAICAgDWiv1iEgEEgZkNkP6KxDBYGAgFTm/LEWAYFAuoA4f9CTCgIBAYGAgEAg1Y3L7OcPN1jrUUEgkCYgbq8YQQWBQIqAqB6MooJAQEAqcYO1pukDor1iJBUEAgICAQGpwPljXQICgakD4oDOaCoIBAQEAgICAQGBgIBAYOqA+P8Co6kgNwnx2qYOiP+DMJoWCwJarJtUubUJCARStDAZdmnt4JpUEAgISCXOImtKERDtC6OkX3gz7dyCvJ6lJ7R3eARkPSb0Sa1ACQoAAAAAAAAAsKKPj3+VWiDuTOsmigAAAABJRU5ErkJggg==", 200, 126},
		["M1911"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAB+AQAAAABJsGNbAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4cOmUuw2wAAAE+SURBVEjHvdQ9bsMwDAVgCh60VTeoLhJAYy9VVDqaj+Itq0cPhlXFfwosvqomDHP0l0QO+SiiO+sbyo9APAIb5yJq4l5hFhfLWsQz0kLp0vOHikBcw8kAzl9EQ1FQCIsTiIViBKIvFfacHkp3p1iBeCRsdGaxSHh4ieMlgPMrUv7auG1cIcMmmns4157rXi+TzJX/wrqDeef31/EHcbvYwAsVsnZuStOl/4rZRfMy3iTTX2LOSurOB5RPvjup1w8gbXHXb5Pr1HCQHJAeymHYb3cisdLSsmdv1bCff5XeegNkPCWmIgMjDRTFNiZ/5yrR68KdEcONpiJWLIERJxCPYiASGB0sqiJcdBqxcKHSAjEwOhKxMFRYXEVaRrxYAiPxvCh460iEsFgYRMKiQHRoTg+QdNREiJ4B0ReUi+oXWBTkflSsh3AAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE4OjI4OjU4LTA0OjAwWbCg2gAAAABJRU5ErkJggg==", 200, 126},
		["M45A1"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAB+AQAAAABJsGNbAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4cOmUuw2wAAAE+SURBVEjHvdQ9bsMwDAVgCh60VTeoLhJAYy9VVDqaj+Itq0cPhlXFfwosvqomDHP0l0QO+SiiO+sbyo9APAIb5yJq4l5hFhfLWsQz0kLp0vOHikBcw8kAzl9EQ1FQCIsTiIViBKIvFfacHkp3p1iBeCRsdGaxSHh4ieMlgPMrUv7auG1cIcMmmns4157rXi+TzJX/wrqDeef31/EHcbvYwAsVsnZuStOl/4rZRfMy3iTTX2LOSurOB5RPvjup1w8gbXHXb5Pr1HCQHJAeymHYb3cisdLSsmdv1bCff5XeegNkPCWmIgMjDRTFNiZ/5yrR68KdEcONpiJWLIERJxCPYiASGB0sqiJcdBqxcKHSAjEwOhKxMFRYXEVaRrxYAiPxvCh460iEsFgYRMKiQHRoTg+QdNREiJ4B0ReUi+oXWBTkflSsh3AAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE4OjI4OjU4LTA0OjAwWbCg2gAAAABJRU5ErkJggg==", 200, 126},
		["M9"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAACCAQAAAAAr4Lo5AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4cMmv1S14AAAEcSURBVEjH7dRLboMwEAbgsSzVu3IEepL6Sll2URWO5qNwBC+9sOw4gBPA8weRQpRFZgV8eOTHjInesRpfUH6g/KJ3Efu4SePGBz1Ie5Xo8y9QYhGjyFLCIAqKhtKUEqGEI2TT3P4hzEL9wyKeJBKKglIx4lCyaMtkuQTLMd208LFoKLOVGuLSWRKOGDGqK6TppYVCSYiTQJW5J5YVleTEiN8mcVU6JBKI62U+a5HFIhFQyC13R2bxvKTPf1C+l+czSOrMz6WMpUj0QcJzYi7DWUk7QDUrl0XGuUy7BItlJAzzm0V96zJWLBQDpWVE7ypjkxwu+bAPFrEifieRK+I2iXp5sTtJ9SISniRcheCLQl/vMF4MlBYKvWNLnAHpIRyBZ0kyPQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTg6Mjg6NTAtMDQ6MDBqX+69AAAAAElFTkSuQmCC", 200, 130},
		["ZIP 22"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABkAQAAAADr/UKmAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4dClrswoEAAAE6SURBVEjHxdbNjoMgEABgjYcefYEmPgov1gT7ZjT7IjY97FXTC5tSpssALnSYrtl0dS5qvojD8CNVtVoAL2qRNJaVpO0OniOKINIHkUTUH2Rgv/O7yA3klil9x8W4kuiXApzU24phc3PES7mnYDcXWOk7ZpHcWZm+lyGOCZnXE4Q9gMjZjVbLyq4kJ4O7S0E+nNRvF7WSkJ3vEntalh387KOzXI2vtSVyC6NgiCSj+W+Srr1UMM+3i67L0od0yiJKIl+LZAU4qVlpWGmfxURx6yobbS8q1D0VjdcBU/v8ojJiapcpFVwWQuNkO40HIsalFtdOEJziwrqq9Zn4DnQw384yBDn6H1Ii2Jjvv8rFX11i+TFGhrZdNXUu8RHynH1VYvp9Jl18FGCrcnR5zkm07DGq4Y9e+2pZPACRDnKi5rGIGwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTg6Mjk6MTAtMDQ6MDAB14t5AAAAAElFTkSuQmCC", 200, 100},
		["1858 NEW ARMY"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAACDAQAAAADgvGmcAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4dGKlVs8kAAAEdSURBVEjH7dNPTsQgGAXwj7Doshcw4SKT9Fru2oN4GFy58wQuMB5AjBsXTRE6ZYY/74u2zk7eqs0vUHgUopaWlv8Z5XzM5VXERzkNQSwQPQZxi3/uLk+rGFckCr2W4qK4HTJtMrIysKJY6dkVqN/Lwsi12hvIF2GZ6yPdYjNZe7P5TpKuz6IzEFfJIRFDSD6SUmLO/8tnNVc8uPdsi8lkDgzp4B7TBkwlY3FaRQPgK3EBcz1EckOKe5Gm5ybbbuIJyLCOuNslYbIXTh5ZEQ9IfAWLeKYTlBmLDL/rE93Dciy9kYViyEoDazP+8DQU7XsgRiT4TKgazLQVOt1OxgPiOBHVpf2LSFY6dgW89AdEHZDhoOidYxS+vC0tP+QbYpEp3Gq6aocAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE4OjI5OjI0LTA0OjAwexeoiQAAAABJRU5ErkJggg==", 200, 131},
		["EXECUTIONER"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABvAQAAAACBOrJlAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4dKmGC4kkAAAF2SURBVEjHvdWxboMwEADQI0j1UKn+gUr+jU51P6tDpPAp/RRvXfsJjN3q0YPrCwRwsH2XEIS4BaEXm/PdQQB2iAMrAg0jEtuFohHdtFsUhWM4OVztJJiHY8WPUA23/6UIZs0BJCOiLSUM4jgBrznRJy5rhZxIVuptxNESC11kcB2C/DhfUejzX7tDSP4YHyWvZ0ytOE2Uop6W2wx/yJztcT7385jPc5LziZf5e6NXy98oDSMBG2q3ZzSI7HPoNYWcNhVcKGbJmuqu+CqXaXI86ABJXEXZVKYxcKBaTqRJRUYRmagBlIO6IUWUMrQngIU6hbHUjwmO4lj5BEGJ7OUphUuFfR3gCC+UQIB3eCVK7bvfa3gjRYJqqCb4Li/x3ZLS1SwZqKkJDipTZb2eBGbfh0KAkbw0Y+MsEHFHfllpKdG3xewkzYo1H5RcRhQel7Cp+M1E4/zvc7nYnaRdIYYUxY3BDZFcS/s3mC5O/w2hE+i2Y5bwcQamMwaPXU/FIAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTg6Mjk6NDItMDQ6MDDeqJQ0AAAAAElFTkSuQmCC", 200, 111},
		["JUDGE"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABuAQAAAABKZmHAAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4dMnLueh8AAAFeSURBVEjHvdRLbsMgEAbgQZZKV+UG4SJVfa3s4GbhKBwBqRsWFi62xw/MTJsit5ONnS8D+AcH4B/qRbj1shvn8ngrt6tVpppuFSlp7gmwtZ8qrqIZea1lwA7bc+IrSTh/MIzAMHJiWOlZ0awoVmSD1PNgBjBy0tUSuWlG98PjCHawOhs8BkQLHh3JCjEYLs2wQsBoqQDWLH8jAyuxQcITcgrnwcr4jKhLRTdI3yAGv/msZPutYAW7NxG79Glaqa/Eg94HKrYniy8Eox6MB+VIUVlsIRho7ByoAtbYeAm19Lu8MeLPMkcSTRAeboR4Tcjy/DJAgHdKugD3/DmWwMzuuSMyomUgxOUO+Sij7lA+8pUlRVuTgBR1fA0PYqdtKvcNN87mlZxaNqlrEQJws1lJl8pwlczHLV4qoUF8g7gGsZcKBUvWrKQGGRqE3J759AZSOi7qb0RwUc//SPD39QUeV33SIKqYJAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTg6Mjk6NTAtMDQ6MDCFnYWDAAAAAElFTkSuQmCC", 200, 110},
		["MATEBA 6"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABxAQAAAAC45tGOAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4eAn8aGXAAAAFQSURBVEjHzdQxboUwDABQR6mUpWrWDpVyhY4dvsSVegPSe3XIUXKEbM2AcPUD5ENiU0AI1RPwCBjHBuDKkLzY4oIIrMRJsG8QMbvCLkuK6RFgsM/3DHFfpNNRKY/gBUfR42kHTRDo5CObLDqvsVMuVRwRl+Cp4USzQnwO+lMlsBIPizkgLSvIiWBFnSVh/v6foqKSWpE6UdWX6P70rNgtUmQwnzzNymJRmMui1H4h4/aEdv76FM2YlekLmDYbVKTlG2QoJaUdP0B4UtyqOFLsJ8ApYv6QQEiqjo0gyrINFbWvnLi3+m867I97BgW0KHgpYRgSL92NlgCu2p7UIf4GypPi9BeWMDSplUVDZQF4ryCVugcq7tLtFDNNMimBlKZq9G3iSGmX07lZSABck36niFWhCyovErUqcafoi8RcJA1bnaukZXvnfwhbN2ZI9scvLezT84FcIRUAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE4OjMwOjAyLTA0OjAwZ3luxAAAAABJRU5ErkJggg==", 200, 113},
		["MP412 REX"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABoAQAAAACcP4LdAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4eEIyjaDgAAAElSURBVEjH3dQxbsQgEAVQEAXpuEAULrIS10oRBY5GlIu4S+syhcUErxdrDfOJTKIUmcrSE5b9Zxghtnp8EIfysTw5quoTygIl3eC1ESpHPBJLSDQUNSAGigOi3wkJ/S9RvyQLlBlKPMo+fqV+JHMtewYTlFiLKRJqsVDcDbzgJYhLI36FfJVaKeE2IstfNnKNQE1AkuZEQzFQ1ggWLOwXOCi+yAsnSWZ55sJJMmdQj4Hc8pzFikxs+VWqlm1ywkWYiQknD8eTcJEVbgyu8rFfmSoceqO7pXqQaJkJdex07hIGhANBXUnnRPZl4UQNiGYXQV8MuyJGxbJrpS/ftBRL4MRDob5wIPtystmqL7ilJ5ttBsT2W3pS3ID4AaG/lAlKQMI27gulSKXVNsHrMQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTg6MzA6MTYtMDQ6MDBfnEpJAAAAAElFTkSuQmCC", 200, 104},
		["REDHAWK 44"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABjAQAAAAD2+HIeAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDA4eGIJ44AoAAAEySURBVEjHvdZBUoQwEAXQnsqCjWUuYA0ewaULyxzLnYkn8Eo5yhwhO7NA2oEEBpP+KhROryge6ZB0h4JoZegIpZuuHgppZ7EBCjMvUDO7fMlTuOnBkyiKBfE52SQHriKLgtJA0bWkNbxqNMbyetFQ1AYhLHbDGEF8Kb5oCCiLrXbfxVwE5SpkWeoezFJMstjpsrtbOdXfpPtfMVcSeyVJt9+hvM3nfI5cbLJOlM+eTAnpiMRnOsoSjoI0We6g3FQyNlW4FcYk0YK0v0jjnioZCxdUeJQlHkKoxKYCvJxk6cl6STolHJGxPJE+OAJRXCcbynN+rXtCQmtE/ShxpTRSc87Sbxgjz6PhW+vLd7aIdlcxu4qF69kqHgqtl34/MajYw14D0agNhr6WF3pOB3+79owvdDQLD3xuwdwAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE4OjMwOjI0LTA0OjAwRoxcgwAAAABJRU5ErkJggg==", 200, 99},
		["AA-12"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABSAQAAAAA53qYWAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs4AFQBOZMAAAEwSURBVEjHxdRNSsQwFAfwlIJ1IXbrQoh3cONCyBxF8AKC24FEvIg3seBFAl6gMpsuQmK+qskkf2cIom/zkv7g8ZK+lpCDMUKh2e4UygWUy2TNMrk9Sq6hPGayTdb3LSJ8OivlXaRHVInsgtwU0kXZQlHfchKW47OX3vjUORn9fj+cUFMLJ6wq2gpvEPMHoqDY+HfR4HYUvLcFigQi/QBw8LwU+TVOUZ5Ceklmk8degohC1lzIvM5QIQSJ9BMph0L8lFM9lTJ5UaUsJMimkLBj+q7PhS0x6yu+J9mJU1nDaPMWm8mjM8t5D2QmdemhDPaKkExAxiYRtr+a0B+E/KIwfUBkpVqDDOYBiHsLdSGvUNxfty7Ef0NVoQZUs919ALG1OBCiodjvDsvcILCaIMfEJ5Dk0z912VnTAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo1NjowMC0wNDowMFJhpZcAAAAASUVORK5CYII=", 200, 82},
		["DBV12"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABPAQAAAACGlrdTAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs4DrO5FJQAAADOSURBVEjH7dJBDoMgEAXQMSzYlSPYW3bTRBIP0HVvw1E8AksTLXSAhIIw1ppuTPsXxPFJEAaAfw4efUoKJpPC2qTgm6SxMfOaiE3CbJptwjNp30j+LuROCkYdTPBEu/p+UC6FqOxqROmX4s5f4jjhw7AU7XpaETP4bk99KYqSh4o3hJJb8QfSj2NTyBRkQNGVORx3KQqBVRE4ky/FvGTMpPEfthUJaS18WZhrdCnmcxGzE1MRNrtO1MTveZdYQmCXUOtAp0mRlFwpgDP8ZJ6LY8WA0lfYtAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NTY6MTQtMDQ6MDBqhIEaAAAAAElFTkSuQmCC", 200, 79},
		["KS-23M"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAuAQAAAABFPmusAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs4GEdtocUAAAC7SURBVDjL1dI7EsIgEAZgMjhS5gi0HsIZPYpHsLSSPRo38Ao5QjpTMK4YF+S1hTGNWxG+gfl3iRB/U9v2tkRfE33sE1AYy0p0iWhM65HIgRXkRLKiWOkzcJvfoplSrmxoQ9C9ZnaJd2bitDjHo35sBkKjkxSnd1sUKcoo4egXuxj2Ix1C+lwkfgJj8ZAaQuShFBsG05B5/17LbQZQtVDHbbFz6lro/zG2lLKNLPW30vMyrCpLEiwREOvVE5faBObp6o8ZAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo1NjoyNC0wNDowMOQLhvkAAAAASUVORK5CYII=", 200, 46},
		["KSG 12"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABCAQAAAAA6CKSNAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs4JoYMvG4AAADySURBVDjL7dOxDoMgEADQMya1Uxn6AWz9DO3aP+rQRP+sfopJh64kHWpSw1Usp4JA1HbsDQZ4HhA4AIyoqcFK+F7OM3KEJQ01eG2JpEbmlv0dsTGByRPqsIQjeoQNotc5Jrp/Vb007iTHcVR9ogT0xV9+LHKFFCG5tV9GfXX7egNKKoiGP3UBtYWHD1QlORKAA0QNSbotWizicYnhU1XspZsEHPKZHhKPSEuogkOCsDGlHmTnlAxftggSLLxiPqde8qlUJCUXPjGfJtIAHfQMyWlgIpk+0EhdsDPWSIxysSQBaRYLC0i9WHhAxIqc5cLsdd5vR6asCkEw3wAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NTY6MzgtMDQ6MDDvAewTAAAAAElFTkSuQmCC", 200, 66},
		["REMINGTON 870"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAjAQAAAAD5oHhyAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs4OHwDgQ0AAAC5SURBVCjPldFRCoMwDAbgv/jQF5nPIswr7AY92no0j1LYBfLYgTOzirXShLE8Jf1qagjwM26qdKo45rksz5SZlyO/W2Z/FGt+jVg0k8WwJp0qTpXrabD5/ab6hMMGD1sLbaNQ/QPpnfV+dKKs9+NT6pYavfdiKecCxv1wNHROTMWM8wDKW2pKiQNCXojxhVCPSdhlktZ7WSbLkAVmkWWGEO6y9EpIlaDKpIpX5PNSRGyFtAUF0OLv+AKh7kw2X8ZddQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NTY6NTYtMDQ6MDB5UZ7JAAAAAElFTkSuQmCC", 200, 35},
		["SAIGA-12"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA+AQAAAABG6Gk3AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs5BqR5recAAADWSURBVDjL7dOxDQIhFAZgyBWUVzgAiYWtI9wqbuAIxwAWlo7hBjIKI1hiJPzy5GLuvPdiLK67v6D5CIEfUGrNMunglHacYEi2aQoNPslTMZy0ngZOLMrQ8zLNaDXMoswt8ULxS0umEllJtS1X5Qk8yuyNs+/Jo/N4jesRULMyk9I47zkJRS47RspuNE5bRgKJP8yFytXofY+vd2DoAE2mO+LEsBIH6UaH/CWBikiM1IoSPQhZAiNWlkil3wWxorSIwg4MEiM6knCr1etwkkQBhG+65s+8AOvhQeZPRMLqAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo1NzowNi0wNDowMN5z+5MAAAAASUVORK5CYII=", 200, 62},
		["SPAS-12"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABCAQAAAAA6CKSNAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs5GrB48agAAAD9SURBVDjLvdSxDoIwEADQa0jEjT+wv+HGNxknp/Jp3VxM+AUHEwcdmEwH0rMtwQLeoRD0Nni59u5aAPh/qDPxUqAPSlJWcjwcc0oE2l1PNnExuy8VJTkO9nlJA3jVALInrrICJHYSZcyAdStVEBN7GUQdnBXkJGElZSVjZViADUMxVGm3djJk0aFfWkyc80+lIoWr2sJncXOziTtj+SZu1laQ4s7nJFD7WrRfoHfZ78LdHYCtfzCdq+vFAhUKL6IiJceH0IyYBJjVyhUnRU0LhpKJEN3mBmIZSUaE2d/NmpOsN8TvRDZf5iQhfzezRY2Iniw4I0ct2o9k91kynvsKB8H7RYIdAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo1NzoyNi0wNDowMJxW/O4AAAAASUVORK5CYII=", 200, 66},
		["STEVENS DB"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAzCAYAAADSDUdEAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAFwSURBVHhe7dpRbsIwEEVR6P73TImUSCk4jikOODPn/BAhpEL8rugHFwAAAAAAAABg5To/suN2N19ygOvdfPkx05nu/V2BVIgil1Is6QMRAYtSID/zI6RWimOS8hvEt0bZ1kgyS3VDhFEnkGcpbogw/hJCu+FvVG3ctYPOGIXh9zfEDc045j3GPoaPH0KGGIw7jkMOMmoEhp/PWwce+dvgMYbpswokn6YDjxzC2hJAKYbSc8RXPfBpFPNlCKXRT4+l51ueI77Nn5pMg5gvQzBu/mNzNFEC2Qtj+Zy117W8hpiKB74M4uxaB93yecWRU9hADJoe/NwdKkIG4tuDXk7zL9Z69LX3Jw56Gj6Q2uBL71Mg9DRsIK8OfXnPAqGn4QIxcEbyNMZvxCEKRvXVQITB6L4SiDA4i+JQj4pEGJzNRwIRBmd1aCDC4OwOCUQYRNE1EGEQzeagX4lEGET1ViDCILqmgT/GIgwAAAAAgDFcLr9TRLgwqm2TIQAAAABJRU5ErkJggg==", 200, 51},
		["AWM"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABBAQAAAAC8nNYjAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs5NoKgnUsAAAC1SURBVDjL7dKxDcIwEIXhF6W4BskLILxJPJq9AQtRmAlYIWxgUqWwMI4TQUjuJCToyF/mK845G9j6JHKiAJb5XKfz0anESkkW9yu5phM7B6j8niQ5oGbFslNyOs9vRXkFNON5+6XkYpEoyqw7qlqSsQaS4AuJ09H8av+BOlUO//YwBmmpo9V2ZgJWbjTsiBEVdpYXfel5CcbDhrXALP7kKU6zNz2IEoV48WVD/LvJyWJE2fqLHkzbFClI2uwUAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo1Nzo1NC0wNDowMAEM5N4AAAAASUVORK5CYII=", 200, 65},
		["AWS"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABBAQAAAAC8nNYjAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs5NoKgnUsAAAC1SURBVDjL7dKxDcIwEIXhF6W4BskLILxJPJq9AQtRmAlYIWxgUqWwMI4TQUjuJCToyF/mK845G9j6JHKiAJb5XKfz0anESkkW9yu5phM7B6j8niQ5oGbFslNyOs9vRXkFNON5+6XkYpEoyqw7qlqSsQaS4AuJ09H8av+BOlUO//YwBmmpo9V2ZgJWbjTsiBEVdpYXfel5CcbDhrXALP7kKU6zNz2IEoV48WVD/LvJyWJE2fqLHkzbFClI2uwUAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNTo1Nzo1NC0wNDowMAEM5N4AAAAASUVORK5CYII=", 200, 65},
		["BFG 50"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAsCAYAAAAgjfcKAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAIXSURBVHhe7dnZloMgEEXRpP//n7tTvdCFhFEKLeHsl2hURKnrkLwApL3dJxT8frjJ3fvDTaqK7Ss0at8r4QQqGhWQmjCkEJI+y5681qLzCy3cVpaV2outI9+5yV2pnVaxfaAeAZkcAenz4z4BRBAQIIOAABkEBMjgJb2S/7Lrb7t9X2pP1gvX2bb1ldppFdsH6nHyGmkWcEvxntkv4ejHCWykGRBBEduWHJyaQlhxcFPnRc7FtsyfFuG8T5a5SRgUHZzUYMbMPsAt52J2K4a5OyDATMKLwNfPvITDjhWv2NbwP4hhXKzuR0CADAICZBAQIOPrJZDnXqSs+KPBYwMSDtZMwV6xEK1SCYgM6LadPx3KLWsh7bjJA422a6X6gLmoBGSErQDD/pQKc3T/S/vHXMy9pEsBCjdritV+YRwzAflPxYeb3cW+y2ldv9aodmHb16CPfkQJjSo8zeMgHOs6DPxV4bii4FqOJdcfaeeK/sKmSx+xpNCEmzXBWn9gS3dAagpM1hFu9jFa7kKYU3dAckXkcnF5MDQL+47+w47D4GsU1t0FdeYY/D6H2999PLiXWkCsFFLpGLZ+1hyrlWPCfaYKCEUPbeb+ST+rJ9xAyqk7iLWr8FP7DfsefwchHBjpEJBZi4hw4Kxo4aSuytYKrebuQTjQ47HFUxMOQUDQY5pfsYARHn91Ld1JuIMAgdrHLwDAaa/XH7tZAH+5Yt4HAAAAAElFTkSuQmCC", 200, 44},
		["DRAGUNOV SVDS"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA5CAYAAABzlmQiAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAICSURBVHhe7drtcoMgEIXhpPd/z61rl441wIJ8CPg+fxpJRlDP0WbaFwAAAAAAAAAAAAAAAAAAQEtv/Qks63ujL3fvjb40felPAB48QQZwvsPF5Nz98KvkCcLJHkROSUZyDJt1DDnBrOm8rpx1LF0Q64KhvztKUlKQJb+DyAkRuglc1qXNNcOa0n7KgVyhXCU/QSR0QjeHNcMaMY/iu3HvO7o1X8258ByhXHUNN3Bk3exaOuY6tg4KgiJ3hrwHCoJsq5fiiIJM4EmBHE3XgtS60LOXlsDPo/kfCl0YaoRCiiF0E2ju8hOkRuBTtCyEOwaZw3c8vnEZ05eX+ebCmIb8VxMJoaNDXhI0H307yn3OmgPPNkxB9jYoHQraW7DRzQ+x93x8n09ZB9Z3e0H2Rmx0M0hC7OhQkeOcofl9c+0L2OgmFte9IBLGIx320izudKgKtz+Z37fv0LhjvY91mBdZwqAv/8kNSGg/Z7WCl7pu3+dS1xCaw5K6f9zPvFChEMQucm5wagcmNn/NuXKP06l9vGjnckFKtQxJbM015716bloeO+rq/h1EwiF0Exha84JoH/7oMDAFM7DWrxGjhb7neq25QkY7ZwgrKsiIF9oKbe01W/OJEc8T0ix34UYoCIVYx6MKQnCRa8nAnEtCMQAAAAAAAAAAAAAAAAAAAABgLq/XDwAhJFCK7k4wAAAAAElFTkSuQmCC", 200, 57},
		["DRAGUNOV SVU"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAuAQAAAABFPmusAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAs6Hpw4ZnIAAADmSURBVDjLxdIxDoMwDAVQ0wwZI/UAzRU6dsvRQGVg7JGaoyB1YGVMpQjXGIpKcEQ79UtMTzixHQCOos+CFN1UBqMo2FukVIJM+acEupsWRKG3eJL6oRmgF4WCbVbSagrXic4X0wQ1pmkVDqOYrNiN9Grq2aXnHC8sfiOUmv+UBPek/FoiuEaWwIOirhYJBrvDPLGS+1lEYadmOfOz/JBHsZp1SZWLWQ4bGVdB8rwm0r/lFnNSh0RagOI+SrJ+FtpS1L+I35UhEcdvmcTkZBAEZokZiRkx6LfC5XULOogixcWc2B5+zQt5h6xodRWTwAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTU6NTg6MzAtMDQ6MDDCJ5LHAAAAAElFTkSuQmCC", 200, 46},
		["HECATE II"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABDCAYAAADZL0qFAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJjSURBVHhe7dzbUuswEERRw///M0RBTgmVNB5Z17H2eoGQHF3s7jjmVHEAAAAAAABs5+fFfwsjvv1XAAkUBBBQEEBAQQbjPsQW0wUhbOjNbEEoB0bgI9ZAXy/+WxhBQQLuquT4h8Bh9h3tDHLLd+WwHLXjhmOltFw3+tm2IFcBjuXmKR3ndHfdGMt8QayiIDZwDwIIKAggoCCAYNvPwfE9THhPkLq/ie8ZUq8pEY93RTtf6biQUZBAGK74eW3wUuOmaMdztGM6JePiGgVRmhk8CjLPFgeztAwthEF189cGV7uH2nnw37+DqT0Jo9Wc9FX31MuuBak5z9Ix+zyxepDunPjV94RxUvkJ85HL1/vXvAQJT5YLf+7nIf4fBI+mKYGEggCCd7v4iIUnk64iZ/Zzr6EgDyOFQSvOQ4sxa7k1heuI13gltYdwjNTzzu0JsZ7cSd7JnRxLx42CPAgFaY+CGEcp+jL1WyzC8McdB8c/REdLX0FSIdj9SkcxxlquIJoA1K7VzbHKfktojg3aWuIjljvxJ/8jkfZ1KTX/Fvv5hGXGO2pNWO+sN5zP2n4xx5QriAuK4x92N3IuPMs7OCPeTVuHdMYVoBZFtadrQXoGwlpBKIdN3QrSOxDaNV+to8feQ72PA/p6bEFK5q/df++9Yp6mBRkVFM16S9ai3f+o/WEdTQoyOjia9ZauKTXm6H1hPZ8AaEIXmxUgzVpL1+bGnLUfrOsyELkwzgpTbj0hgo5WzAWJgmAk/mgDIKAggICCAAJzBeH+AiOZDVvqZp3yAAAAAAAAAAAAAAAAAAAAwJDj+AXTxyx5L2bITQAAAABJRU5ErkJggg==", 200, 67},
		["INTERVENTION"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA3CAYAAABJnAVSAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJiSURBVHhe7dnhWoQgEIVht/u/54oNinxwHGEGAb/3T7ZtoHBOuk8bAAAAAAAAAADAol7xK3Y+v8XD7fUtHuJh2PiCvBw576IczXuE4vpjgXekkFoG8moZSiiIv6kWuDVUKVAW4SwpBdZrrqA0H2w9qiCroSD+PuLX4VEO3GGaggB3oCCAYJqC8LyNO3AHAQTT/VVu+bCe7kJeH/iP7nK954OdRy7wUWC1gWv9/eRoHK2r8+G6pRa4NXDWagOsvQ4K4u/yAreE0HtDW87NAwGen3oDLcLnEZjRSrEKyv3jdBFaA2i90BSin9lKcjUbmutzLYj1ArecC3BEyqnr/0EINGbHPwoBgViQ0e4A1o9swBkxcBYFsQz1aIVd3Wx/kK7mQ3N90xTE4lygZ7Vvs6MgHYQ12J+/dl3Orls7DurwId1RCG8Qv8WEXAtCOP6wFnMSN+3s9o5zrcXgEeteh3cQyjGWUIRcfBnO+AxSKeb0V3wZi6EgjryKw929H3EDWzfCOiCa8wlzpvflx9bC2PHwrTTP/j010rhprHwei/EhW/YOMkJ48jBboBz98YjlLIQ62B8H0nESX/r3c8rRj7jQ+abUsNxI7bmEOdN782NrYex4+OY1z95+Xvha7g6SB7VXaHuhHP1NUZAZgu4dXspxD3HRW4Npsamac9DO03o9udKcluPntNcHexSkksW1YXxuj1gWAbIsB1DDpSC9Qks54E0sSE0ArUJr+TgE1FKHWQqsVSkSTTlq5tSMq2V9zRjTkJs8YkEoxDMNt+le5QhKYxN8SIYNh1QUQg0AAABMatu+AEd8WGTjiGPEAAAAAElFTkSuQmCC", 200, 55},
		["K14"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAA4AQAAAACQsYoqAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAwABEG8V/QAAACrSURBVDjLY2AYBcQCAVJkEgjJSGDKVEAoC0wZG8b/IPAHU6aGHYcMz38I+IchI/8fAzTgleH/g0OGH2ivPYbEAZCW/9jAATQ7oG5jjQWbhkUGCmCmPcDwC1DmI8xkDJkH//vhXkMC7BAZTMNAMh/+z2NowCETgy3umYEu+PsHh8xPrBIgmf/YZRj/P6jHIfOPwf4HAw4g/weXDDtOGUacMrCEiAUoMIyCgQQAoaLQQgpOpv4AAAAldEVYdGRhdGU6Y3JlYXRlADIwMjEtMDYtMjlUMDA6MTg6MjEtMDQ6MDDgH3CPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIxLTA2LTEyVDE2OjAwOjA0LTA0OjAwZ60xTwAAAABJRU5ErkJggg==", 200, 56},
		["M107"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABKAQAAAADWWybgAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAwAFrIFJrwAAADESURBVDjL7dJNCsIwEAXghCyyTA8g5BrewGOIJ2mhF+iBXBS8SI8QdymUjmlSRJJ5BUHRRd9yPiY/kwix54+iGr5+WMRzMgfRNJcg6d62lpeYj8mFiN0ndikowrFXNUxDqunQk0XXUcJqVV/djtfupSXLc7I2Fwd7ktBUypqvSzrBGcrmTQ35ZWghQzFQvz4pJ4kKif8PS43lBFfjZIqiGUlvbUqxS0GOYykxyksgGopxUAYkFkv/vhgoooEitgTAnp/mAfYTY9j8FhgdAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNjowMDoyMi0wNDowMEZYAwgAAAAASUVORK5CYII=", 200, 74},
		["MOSIN NAGANT"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAhAQAAAAC0aNl5AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAwAIpOx0gkAAACXSURBVCjPldAxDsMgDAVQMzFm7dbeJEdrpF6oR7DUi3AERgYUp4KkAZuvqH9Dz3wjiP7OrTt5YSuzdMk/caKzXoo3kneZNDB4wC4+DtZIKMvZ6/aSZzu5NDCpijMQGknqT49xkTiUT+i3n+IepqxKdm9zpUpwL3OlClE2UL7Azh8SoBCSBIXHMqOyryQojGQlJBHJHZXhbOBcCQKuzU5HAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNjowMDozNC0wNDowMOkiNqwAAAAASUVORK5CYII=", 200, 33},
		["REMINGTON 700"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAsAQAAAAAI9sqnAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAwAMGAIo0EAAADHSURBVDjLzdJBDoIwEAXQQRZd4g16BU8gHsWbtEebI7B0WW9A4kIWhLEFirH8iS79SaHNa6Z0AtH3NOnhGImPQwISpkr24kTkyQ6I5PyhOFWILNVcqRK7A/pmjwZ1k2LLvBEorRQZdp/9u9SqfB4z5UqHslgWK74sth0Rr6IIWyRpO7dI0vbgNLkXMG3yWNZbzXGWZp73vX3fb80iQRXuNPE3TeiiyETXFstIJ0WG+Y2kT7MzEvBnrsKKeOexBLKKMBkohpS8AGNim+3Q0fa6AAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNjowMDo0OC0wNDowMCRHVcEAAAAASUVORK5CYII=", 200, 44},
		["STEYR SCOUT"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAuAQAAAABFPmusAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAwBBFinZrUAAADNSURBVDjLxdM7DsIwDAZgI4YsiI6w9Si5FHt7tNyAK0RiYeiQ0YNVk74ISWxBJ/6hQz7FdhIV4JcggA3VasMOCAxLwo46lmXOX8URWVHu8UBHQaJNR229IPES1l6+LJeSi+U841u6QtJGrqRlFGVc6gMcPldD6uziVllCPhomwbwNpmkpa7NWW85hVMnjFFFupYfqvqjZqpQymPLBNnmeFfHDSRF3uyrSW1QEGi/LCHW+Ce2Saf3BKEov/tKTxI8RZR7LqSKlI00uCHvzArY6rLXzFDHTAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNjowMTowNC0wNDowMIhvWnEAAAAASUVORK5CYII=", 200, 46},
		["TRG-42"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAAAgAQAAAAB/NArcAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAwBFEUQdtEAAACqSURBVCjPjdJNCsMgEAXgkUBceoQcxaPpkXqEQi/irluXFkpe1cZU4wz0LUT8cPwlatEAIjFRGZA4WR3GnGIhiAIjtiysZzGl9eRm2UobqBtqG6ySFCN1T2mRJPYSB9HSnGD+klatHiRsolhJopPkBdxOCb2gSR5d6Sq58x7e8pDY1/mmFccTO7FiH+OMn8x/5pA7J95IUm9VEC2K4mWvj+Rn2YoYTmoWRj4paIhatmwtEAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNi0yOVQwMDoxODoyMS0wNDowMOAfcI8AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDYtMTJUMTY6MDE6MjAtMDQ6MDA+BXkfAAAAAElFTkSuQmCC", 200, 32},
		["WA2000"] = {"iVBORw0KGgoAAAANSUhEUgAAAMgAAABIAQAAAACbk4frAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAnRSTlMAAHaTzTgAAAACYktHRAAB3YoTpAAAAAlwSFlzAAAOwgAADsIBFShKgAAAAAd0SU1FB+UGDAwBJo3HJ1EAAADxSURBVDjL7dNLDoIwEADQduXGWA9g7FF6Fm/hwojRi/UoNfEANS5sDGEcShugH6IE4sbZAH2ZdhgYQv7RCXEiFHRGRE4ogAlXGVQoPCG41sTPhA2IKQAuXrY9PBDue8AhkoXftCdHFJYUPKeMBaQVOO+b56p9E7ytL9KJzRE+HbohWwlCTyLSFkBtAyNZN1Jmdptbbu6nTOXU3xaecdUuHtN0ZxYpyQeiORieFgZ6VUDVm1srCmUZTrTLuZtNRq454SoaKpQX9pyrcNjsMGGZIiWK2uoiIbt6LSlE2rFKCRkUMUL4CGFucr6T3G40Kz+MN0ytoaI7RH2/AAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIxLTA2LTI5VDAwOjE4OjIxLTA0OjAw4B9wjwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMS0wNi0xMlQxNjowMTozOC0wNDowMMFAN+YAAAAASUVORK5CYII=", 200, 72},
	
	}

	menu.activetab = 5
	menu.annoylist = table.create(game.Players.MaxPlayers - 1)
	menu.parts = {}
	menu.parts.indicator = Instance.new("Part", workspace)
	menu.parts.sphereHitbox = Instance.new("Part", workspace)
	menu.parts.resolverHitbox = Instance.new("Part", workspace)
	menu.parts.backtrackHitbox = Instance.new("Part", workspace)
	menu.parts.sphereHitbox.Name = "abcdefg"
	local diameter
	do
		menu.parts.sphereHitbox.Size = Vector3.new(1, 1, 1)
		menu.parts.sphereHitbox.Position = Vector3.new()
		menu.parts.sphereHitbox.Shape = Enum.PartType.Ball
		menu.parts.sphereHitbox.Transparency = 1
		-- local box = Instance.new("BoxHandleAdornment", menu.parts.sphereHitbox)
		-- box.AlwaysOnTop = true
		-- box.Adornee = box.Parent
		-- box.ZIndex = 5
		-- box.Color3 = Color3.new(1,0,0)
		-- box.Size = menu.parts.sphereHitbox.Size
		-- box.Transparency = 0
		-- table.insert(misc.adornments, box)
		menu.parts.sphereHitbox.Anchored = true
		menu.parts.sphereHitbox.CanCollide = false
		menu.parts.resolverHitbox.Size = Vector3.new(1, 1, 1)
		menu.parts.resolverHitbox.Position = Vector3.new()
		menu.parts.resolverHitbox.Shape = Enum.PartType.Ball
		menu.parts.resolverHitbox.Transparency = 1
		menu.parts.resolverHitbox.Anchored = true
		menu.parts.resolverHitbox.CanCollide = false
		menu.parts.indicator.Size = Vector3.new(1, 1, 1)
		menu.parts.indicator.Position = Vector3.new()
		menu.parts.indicator.Shape = Enum.PartType.Ball
		menu.parts.indicator.Transparency = 1
		menu.parts.indicator.Anchored = true
		menu.parts.indicator.CanCollide = false
		menu.parts.backtrackHitbox.Size = Vector3.new(1, 1, 1)
		menu.parts.backtrackHitbox.Position = Vector3.new()
		menu.parts.backtrackHitbox.Shape = Enum.PartType.Ball
		menu.parts.backtrackHitbox.Transparency = 1
		menu.parts.backtrackHitbox.Anchored = true
		menu.parts.backtrackHitbox.CanCollide = false
	end


	menu.activenades = {}

	local shitting_my_pants = false
	local stylis = {
		[525919] = true,
		[1667819] = true,
		[195329] = true,
		[5725475] = true,
		[52250025] = true,
		[18659509] = true,
		[31137804] = true,
		[484782977] = true, -- superusers end here, anything else following is just people i know that could probably have direct access to a developer console or data store or anything to catch us in the act of creating and abusing and exploiting their game
		[750972253] = true,
		[169798359] = true, -- not confirmed but this dude has a tag with no equal signs so kinda sus and he respond to ltierally no fucking body
		[94375158] = true,
		[53275569] = true, -- banlands advocate
		[2346908601] = true, -- sus
		[192018294] = true,
		[73654327] = true,
		[1509251] = true,
		[151207617] = true,
		[334009865] = true,
	}

	CreateThread(function()
		while wait(2) do -- fuck off
			local count = 0
			for _, player in next, Players:GetPlayers() do
				local d = stylis[player.UserId]
				if d then
					count += 1
				end
			end
			shitting_my_pants = count > 0
		end
	end)

	local allesp = {
		[1] = { -- skel
			[1] = {},
			[2] = {},
			[3] = {},
			[4] = {},
			[5] = {},
		},
		[2] = { [1] = {}, [2] = {}, [3] = {}, [4] = {}}, -- box
		[3] = { -- hp
			[1] = {},
			[2] = {},
			[3] = {},
			[4] = {}, -- resolver flag
			[5] = {}, -- dist
			[6] = {}, -- lvl
			[7] = {} --weapon icons
		},
		[4] = { -- text
			[1] = {},
			[2] = {},
		},
		[5] = { -- arrows
			[1] = {},
			[2] = {},
		},
		[6] = {}, -- watermark
		[7] = { -- wepesp
			[1] = {}, -- name
			[2] = {}, -- ammo
			[3] = {}, -- icon
		},
		[8] = { -- nade esp
			[1] = {}, --outer_c
			[2] = {}, --inner_c
			[3] = {}, --distance
			[4] = {}, --text
			[5] = {}, -- bar_outer
			[6] = {}, -- bar_inner
			[7] = {}, -- bar_moving_1
			[8] = {}, -- bar_moving_2
		},
		[9] = {}, -- fov circles
		[10] = {
			[1] = {}, --boxes
			[2] = {}, --gradient
			[3] = {}, --outlines
			[4] = {}, --text
			[5] = {}, --shaded outlines
		}, -- shitty keybinds --keybinds -- keybinds
		[11] = { {} }, -- backtrack lines
	}


	local wepesp = allesp[7]

	local wepespnum = #wepesp

	local nade_esp = allesp[8]

	local nade_espnum = #nade_esp
	for i = 1, Players.MaxPlayers do
		Draw:Circle(false, 0, 0, 0, 1, 32, { 0, 0, 0, 0 }, allesp[11][1])
	end
	for i = 1, 50 do
		Draw:FilledRect(false, 20, 20, 2, 20, { 30, 30, 30, 255 }, allesp[10][5])
	end
	for i = 1, 50 do
		Draw:FilledRect(false, 20, 20, 2, 20, { 30, 30, 30, 255 }, allesp[10][1])
	end

	local this_is_really_ugly = 50 - 15 * 1.7
	for i = 1, 50 do
		Draw:FilledRect(false, 20, 20, 2, 20, {this_is_really_ugly, this_is_really_ugly, this_is_really_ugly, 255}, allesp[10][3])
	end
	for i = 1, 19 do
		Draw:FilledRect(false, 0, 0, 10, 1, { 50 - i * 1.7, 50 - i * 1.7, 50 - i * 1.7, 255 }, allesp[10][2])
	end
	for i = 1, 50 do
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, { 255, 255, 255, 255 }, { 0, 0, 0 }, wepesp[1])
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, { 255, 255, 255, 255 }, { 0, 0, 0 }, wepesp[2])
		Draw:Image(false, placeholderImage, 20, 20, 150, 45, 1, wepesp[3])
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, { 255, 255, 255, 255 }, { 0, 0, 0 }, allesp[10][4])
	end
	for i = 1, 4 do
		allesp[9][i] = {}
		for k = 1, 2 do
			Draw:Circle(false, 0, 0, 0, 1, 32, { 0, 0, 0, 0 }, allesp[9][i])
		end
	end
	for i = 1, 20 do
		Draw:FilledCircle(false, 60, 60, 32, 1, 20, { 20, 20, 20, 215 }, nade_esp[1])
		Draw:Circle(false, 60, 60, 30, 1, 20, { 50, 50, 50, 255 }, nade_esp[2])
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, { 255, 255, 255, 255 }, { 0, 0, 0 }, nade_esp[3])
		Draw:Image(false, BBOT_IMAGES[6], 20, 20, 23, 30, 1, nade_esp[4])
		--Draw:OutlinedText("NADE", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, nade_esp[4])

		Draw:OutlinedRect(false, 20, 20, 32, 6, { 50, 50, 50, 255 }, nade_esp[5])
		Draw:FilledRect(false, 20, 20, 30, 4, { 30, 30, 30, 255 }, nade_esp[6])

		Draw:FilledRect(false, 20, 20, 2, 20, { 30, 30, 30, 255 }, nade_esp[7])
		Draw:FilledRect(false, 20, 20, 2, 20, { 30, 30, 30, 255 }, nade_esp[8])
	end

	local setwepicons = {}
	for i = 1, 35 do
		for i_ = 1, 2 do
			Draw:Triangle(false, i_ == 1, nil, nil, nil, { 255 }, allesp[5][i_])
		end

		local skel = allesp[1]
		local box = allesp[2]
		local hp = allesp[3]
		local text = allesp[4]
		local icons = allesp[3][7]
		local arrows = allesp[5]

		for i = 1, #skel do
			local drawobj = skel[i]
			Draw:Line(false, 1, 30, 30, 50, 50, { 255, 255, 255, 255 }, drawobj)
		end

		for i = 1, #box do
			local drawobj = box[i]
			Draw:OutlinedRect(false, 20, 20, 20, 20, { 0, 0, 0, 220 }, drawobj)
		end

		Draw:FilledRect(false, 20, 20, 20, 20, { 10, 10, 10, 210 }, hp[1])
		Draw:FilledRect(false, 20, 20, 20, 20, { 10, 10, 10, 255 }, hp[2])
		Draw:OutlinedText("", 1, false, 20, 20, 13, false, { 255, 255, 255, 255 }, { 0, 0, 0 }, hp[3])
		Draw:OutlinedText("R", 1, false, 20, 20, 13, false, { 255, 255, 0, 255 }, { 0, 0, 0 }, hp[4])
		Draw:OutlinedText("", 1, false, 20, 20, 13, false, { 255, 255, 255, 255 }, { 0, 0, 0 }, hp[5])
		Draw:OutlinedText("", 1, false, 20, 20, 13, false, { 255, 255, 255, 255 }, { 0, 0, 0 }, hp[6])

		for i = 1, #text do
			local drawobj = text[i]
			Draw:OutlinedText("", 2, false, 20, 20, 13, true, { 255, 255, 255, 255 }, { 0, 0, 0 }, drawobj)
		end
		--(200, 67), (150, 45), (100, 33)
		Draw:Image(false, placeholderImage, 20, 20, 150, 45, 1, icons)
		setwepicons[i] = nil
	end

	local bodysize = {
		["Head"] = Vector3.new(2, 1, 1),
		["Torso"] = Vector3.new(2, 2, 1),
		["HumanoidRootPart"] = Vector3.new(0.2, 0.2, 0.2),
		["Left Arm"] = Vector3.new(1, 2, 1),
		["Right Arm"] = Vector3.new(1, 2, 1),
		["Left Leg"] = Vector3.new(1, 2, 1),
		["Right Leg"] = Vector3.new(1, 2, 1),
	}


	ragebot.nextRagebotShot = -1

	client.loadedguns = {}

	local raycastutil

	local gc = getgc(true)

	for i = 1, #gc do
		local garbage = gc[i]

		local garbagetype = type(garbage)

		if garbagetype == "function" then
			local name = getinfo(garbage).name
			if name == "bulletcheck" then
				client.bulletcheck = garbage
			elseif name == "trajectory" then
				client.trajectory = garbage
			elseif name == "addplayer" then
				client.addplayer = garbage
			elseif name == "removeplayer" then
				client.removeplayer = garbage
			elseif name == "call" then
				client.call = garbage
			elseif name == "loadplayer" then
				client.loadplayer = garbage
			elseif name == "rankcalculator" then
				client.rankcalculator = garbage
			elseif name == "gunbob" then
				client.gunbob = garbage
			elseif name == "gunsway" then
				client.gunsway = garbage
			elseif name == "getupdater" then
				client.getupdater = garbage
			elseif name == "updateplayernames" then
				client.updateplayernames = garbage
			end
		end

		if garbagetype == "table" then
			if rawget(garbage, "deploy") then
				client.menu = garbage
			elseif rawget(garbage, "breakwindow") then
				client.effects = garbage
			elseif rawget(garbage, "aimsen") then
				client.settings = garbage
			elseif rawget(garbage, "send") then
				client.net = garbage
			elseif rawget(garbage, "gammo") then
				client.logic = garbage
			elseif rawget(garbage, "setbasewalkspeed") then
				client.char = garbage
			elseif rawget(garbage, "basecframe") then
				client.cam = garbage
			elseif rawget(garbage, "votestep") then
				client.hud = garbage
			elseif rawget(garbage, "getbodyparts") then
				client.replication = garbage
			elseif rawget(garbage, "play") then
				client.sound = garbage
			elseif rawget(garbage, "controller") then
				client.input = garbage
			elseif rawget(garbage, "checkkillzone") then
				client.roundsystem = garbage
			elseif rawget(garbage, "new") and rawget(garbage, "step") and rawget(garbage, "reset") then
				client.particle = garbage
			elseif rawget(garbage, "unlocks") then
				client.dirtyplayerdata = garbage
			elseif rawget(garbage, "toanglesyx") then
				client.vectorutil = garbage
			elseif rawget(garbage, "IsVIP") then
				client.instancetype = garbage
			elseif rawget(garbage, "timehit") then
				client.physics = garbage
			elseif rawget(garbage, "raycastSingleExit") then
				raycastutil = garbage
			elseif rawget(garbage, "bulletLifeTime") then
				client.publicsettings = garbage
			elseif rawget(garbage, "player") and rawget(garbage, "reset") then
				client.animation = garbage
				client.animation.oldplayer = client.animation.player
				client.animation.oldreset = client.animation.reset
			elseif rawget(garbage, "task") and rawget(garbage, "dependencies") and rawget(garbage, "name") == "camera"
			then
				local oldtask = rawget(garbage, "task")
				rawset(garbage, "task", function(...)
					oldtask(...)
					if not client then return end
					if not client.superaastart then
						if ragebot.target and menu:GetVal("Rage", "Aimbot", "Rotate Viewmodel") and client.logic.currentgun and client.logic.currentgun.type ~= "KNIFE"
						then
							local oldpos = client.cam.shakecframe
							client.cam.shakecframe = CFrame.lookAt(oldpos.Position, ragebot.targetpart.Position)
						end
					else
						client.cam.shakecframe = client.superaastart
					end

					if client.logic.currentgun and menu:GetVal("Visuals", "Viewmodel", "Enabled") and client.logic.currentgun.type ~= "KNIFE" then
						local a = -1 * client:GetToggledSight(client.logic.currentgun).sightspring.p + 1
						local offset = CFrame.Angles(
							math.rad(menu:GetVal("Visuals", "Viewmodel", "Pitch")) * a,
							math.rad(menu:GetVal("Visuals", "Viewmodel", "Yaw")) * a,
							math.rad(menu:GetVal("Visuals", "Viewmodel", "Roll")) * a
						)
						offset *= CFrame.new(
							menu:GetVal("Visuals", "Viewmodel", "Offset X") * a,
							menu:GetVal("Visuals", "Viewmodel", "Offset Y") * a,
							menu:GetVal("Visuals", "Viewmodel", "Offset Z") * a
						)
						client.cam.shakecframe *= offset
					end
					return
				end)
			end
		end
	end
	gc = nil

	local function animhook(...)
		return function(...)
		end
	end

	function client:GetToggledSight(weapon)
		local updateaimstatus = getupvalue(weapon.toggleattachment, 3)
		return getupvalue(updateaimstatus, 1)
	end

	local mousestuff = rawget(client.input, "mouse")
	if mousestuff then
		for eventname, event in next, mousestuff do
			if eventname:match("^onbutton") then
				for func in next, mousestuff[eventname]._funcs do
					local thefunction = func
					mousestuff[eventname]._funcs[func] = nil
					local function detoured(...)
						if menu and menu.open then
							return
						end
						thefunction(...)
					end
					mousestuff[eventname]._funcs[detoured] = true
					break
				end
			end
		end
	end

	client.loadedguns = getupvalue(client.char.unloadguns, 2) -- i hope this works
	client.lastrepupdate = Vector3.new(-10000, -10000, -1000) --- this is super shit
	client.roundsystem.lock = nil -- we do a little trolling
	client.updatersteps = {}
	client.lastlock = false -- fucking dumb

	client.fakelagpos = Vector3.new()
	client.fakelagtime = 0

	for _, ply in next, Players:GetPlayers() do
		if ply == LOCAL_PLAYER then continue end
		local updater = client.getupdater(ply)
		if updater then
			local step = updater.step
			updater.step = function(what, what1)
				if not menu then
					return step(what, what1)
				else
					if menu:GetVal("Rage", "Aimbot", "Enabled")
						or menu:GetKey("Visuals", "Local", "Third Person")
					then
						return step(3, true)
					else
						return step(what, what1)
					end
				end
			end
			if not client.updatersteps[ply] then client.updatersteps[ply] = step end
		end
	end

	client.nametagupdaters_cache = {}
	client.nametagupdaters = getupvalue(client.updateplayernames, 1)
	client.playernametags = getupvalue(client.updateplayernames, 2)

	setrawmetatable(client.roundsystem, {
		__index = function(self, val)
			if not menu or not client then
				setrawmetatable(self, nil)
				return false
			end

			if val == "lock" then
				if menu.textboxopen then
					return true
				end

				return client.lastlock
			end
		end,
		__newindex = function(self, key, value)
			if not menu then
				setrawmetatable(self, nil)
				pcall(rawset, self, key, value)
				return
			end

			if key == "lock" then
				client.lastlock = value
				return
			end
		end,
	})

	function ragebot:shoot(rageFirerate, target, damage)
		local firerate = rageFirerate or client.logic.currentgun.data.firerate
		local mag = getupvalue(client.logic.currentgun.shoot, 2)
		local chambered = getupvalue(client.logic.currentgun.shoot, 3)
		if not chambered then
			setupvalue(client.logic.currentgun.shoot, 3, true)
		end
		local chamber = client.logic.currentgun.data.chamber
		local reloading = getupvalue(client.logic.currentgun.shoot, 4)
		local spare = getupvalue(client.logic.currentgun.dropguninfo, 2)
		local magsize = client.logic.currentgun.data.magsize
		--[[local yieldtoanimation = getupvalue(client.logic.currentgun.playanimation, 3)
		local animating = getupvalue(client.logic.currentgun.playanimation, 5)
		if yieldtoanimation then
			setupvalue(client.logic.currentgun.playanimation, 3, false)
		end

		if animating then
			setupvalue(client.logic.currentgun.playanimation, 5, false)
		end]]

		if mag == 0 and not reloading then
			spare += mag
			local wants = (mag == 0 or not chamber) and magsize or magsize + 1
			mag = wants > spare and spare or wants
			spare -= mag
			-- setupvalue(client.logic.currentgun.shoot, 2, mag)
			-- setupvalue(client.logic.currentgun.dropguninfo, 2, spare)
			-- client.hud:updateammo(mag, spare)
			client.logic.currentgun:reload()
			return
		end

		if reloading and mag > 0 then
			client.logic.currentgun:reloadcancel()
		end

		local curTick = tick()
		local future = curTick + (60 / firerate)

		local shoot = curTick > ragebot.nextRagebotShot
		ragebot.nextRagebotShot = shoot and future or ragebot.nextRagebotShot

		if shoot and client.logic.currentgun.burst == 0 then
			local dt = menu:GetVal("Rage", "Aimbot", "Double Tap")
			client.logic.currentgun.burst = dt and 2 or 1
			local damageDealt = damage * (dt and 2 or 1)
			if not self.predictedDamageDealt[target] then
				self.predictedDamageDealt[target] = 0
			end
			self.predictedDamageDealt[target] += damageDealt
			self.predictedShotAt[target] = 1
			self.predictedDamageDealtRemovals[target] = tick() + GetLatency() * menu:GetVal("Rage", "Settings", "Damage Prediction Time") / 100
		end
	end

	function ragebot:LogicAllowed()
		return tick() > ragebot.nextRagebotShot
	end

	local debris = game:service("Debris")
	local teamdata = {}
	do
		local pgui = game.Players.LocalPlayer.PlayerGui
		local board = pgui:WaitForChild("Leaderboard")
		local main = board:WaitForChild("Main")
		local global = board:WaitForChild("Global")
		local ghost = main:WaitForChild("Ghosts")
		local phantom = main:WaitForChild("Phantoms")
		local gdataframe = ghost:WaitForChild("DataFrame")
		local pdataframe = phantom:WaitForChild("DataFrame")
		local ghostdata = gdataframe:WaitForChild("Data")
		local phantomdata = pdataframe:WaitForChild("Data")
		teamdata[1] = phantomdata
		teamdata[2] = ghostdata
	end

	local GetPlayerData = function(player_name)
		return teamdata[1]:FindFirstChild(player_name) or teamdata[2]:FindFirstChild(player_name)
	end

	local CommandInfo = {
		targetbelowrank = "<number> rank",
		friendaboverank = "<number> rank",
		say = "says message in chat",
		annoy = "player name",
		mute = "player name",
		clearannoylist = "clear the annoy list, if anyone exists in it",
		clearmutedlist = "clear the muted list, if anyone exists in it",
		friend = "player name",
		target = "player name",
		cmdlist = "list commands, idk how you're even seeing this right now you're not supposed to see this bimbo",
	}

	local CommandFunctions = {
		say = function(...)
			local message = { ... }
			local newmes = ""
			for k, v in next, message do
				newmes ..= " " .. v
			end
			client.net:send("say", newmes)
		end,
		targetbelowrank = function(min)
			local targetted = 0
			for k, player in pairs(Players:GetPlayers()) do
				local data = GetPlayerData(player.Name)
				if data.Rank.Text < min then
					table.insert(menu.priority, player.Name)
					targetted += 1
				end
			end
			CreateNotification(("Targetted %d players below rank %d"):format(targetted, min))
		end,
		friendaboverank = function(max)
			local targetted = 0
			for k, player in pairs(Players:GetPlayers()) do
				local data = GetPlayerData(player.Name)
				if data.Rank.Text > max then
					table.insert(menu.friends, player.Name)
					targetted += 1
				end
			end
			WriteRelations()
			CreateNotification(("Friended %d players below rank %d"):format(targetted, max))
		end,
		mute = function(name)
			CreateNotification("Muted " .. name .. ".")
			menu.muted[name] = true
		end,
		annoy = function(name)
			if name:lower():match(LOCAL_PLAYER.Name:lower()) then
				return CreateNotification("You cannot annoy yourself!")
			end
			for _, player in next, Players:GetPlayers() do
				if player.Name:lower():match(name:lower()) then
					local exists = table.find(menu.annoylist, player.Name)
					if not exists then
						table.insert(menu.annoylist, player.Name)
					else
						table.remove(menu.annoylist, exists)
						return CreateNotification("No longer repeating everything " .. player.Name .. " says in chat.")
					end
					return CreateNotification("Now repeating everything " .. player.Name .. " says in chat.")
				end
			end
			CreateNotification("No such player by the name '" .. name .. "' was found in the game.")
		end,
		clearannoylist = function()
			CreateNotification("Cleared annoy players list.")
			table.clear(menu.annoylist)
		end,
		clearmutedlist = function()
			CreateNotification("Cleared muted players list.")
			table.clear(menu.muted)
		end,
		friend = function(name)
			for _, player in next, Players:GetPlayers() do
				if player.Name:lower():match(name:lower()) then
					table.insert(menu.friends, name)
					return CreateNotification("Friended " .. name)
				end
			end
			WriteRelations()
			CreateNotification("No such player by the name '" .. name .. "' was found in the game.")
		end,
		target = function(name)
			for _, player in next, Players:GetPlayers() do
				if player.Name:lower():match(name:lower()) then
					table.insert(menu.priority, name)
					return CreateNotification("Prioritized " .. name)
				end
			end
			CreateNotification("No such player by the name '" .. name .. "' was found in the game.")
		end,
		setfpscap = function(num)
			if not num then
				return CreateNotification("Please provide a number.")
			end
			if num < 10 then
				CreateNotification("Can't set max FPS below 10, setting to 10.")
				getgenv().maxfps = 10
			else
				getgenv().maxfps = num
			end
		end,
		cmdlist = function(self, type)
			for cmdname, _ in next, self do
				if cmdname ~= "cmdlist" then
					local cmdinfo = CommandInfo[cmdname] or ""
					if not type then
						client.bbconsole(("\\%s: %s"):format(cmdname, cmdinfo))
					else
						CreateNotification(("%s: %s"):format(cmdname, cmdinfo))
					end
				end
			end
		end,
	}

	menu.pfunload = function(self)
		for k, v in next, Players:GetPlayers() do
			local bodyparts = client.replication.getbodyparts(v)
			if bodyparts and bodyparts.head and bodyparts.head:FindFirstChild("HELMET") then -- idk just keep this here until the april fools shit goes away? -nata april1,21
				bodyparts.head.HELMET.Slot1.Transparency = 0
				bodyparts.head.HELMET.Slot2.Transparency = 0
			end
		end

		local funcs = getupvalue(client.call, 1)

		for hash, func in next, funcs do
			if is_synapse_function(func) then
				for k, v in next, getupvalues(func) do
					if type(v) == "function" and islclosure(v) and not is_synapse_function(v) then
						if getinfo(v).name ~= "send" then
							funcs[hash] = v
						end
					end
				end
			end
		end

		setupvalue(client.call, 1, funcs)

		for k, v in next, getinstances() do -- hacky way of getting rid of bbot adornments and such, but oh well lol it works
			if v.ClassName:match("Adornment") then
				v.Visible = false
				v:Destroy()
			end
		end

		for k, v in next, getgc(true) do
			if type(v) == "table" then
				if rawget(v, "task") and rawget(v, "dependencies") and rawget(v, "name") == "camera" then
					for k1, v1 in next, getupvalues(rawget(v, "task")) do
						if type(v1) == "function" and islclosure(v1) and not is_synapse_function(v1) then
							v.task = v1
						end
					end
					break
				end
			end
		end

		if client.char.alive then
			for id, gun in next, client.loadedguns do
				for k, v in next, gun do
					if type(v) == "function" then
						local upvs = getupvalues(v)

						for k1, v1 in next, upvs do
							if type(v1) == "function" and is_synapse_function(v1) then
								for k2, v2 in next, getupvalues(v1) do
									if type(v2) == "function" and islclosure(v2) and not is_synapse_function(v2)
									then
										setupvalue(v, k1, v2)
									end
								end
							end
						end
					end
				end
			end
		end

		-- NOTE unhook springs here
		client:UnhookSprings()

		client.fake_upvs = nil
		DeepRestoreTableFunctions(client)

		local gunstore = game.ReplicatedStorage.GunModules
		gunstore:Destroy()
		game.ReplicatedStorage:FindFirstChild(client.acchash).Name = "GunModules" -- HACK DETECTED.

		local lighting = game.Lighting
		local defaults = lighting.MapLighting

		lighting.Ambient = defaults.Ambient.Value
		lighting.OutdoorAmbient = defaults.OutdoorAmbient.Value
		lighting.Brightness = defaults.Brightness.Value

		workspace.Ignore.DeadBody:ClearAllChildren()

		for k, v in next, client do
			client[k] = nil
		end

		for k, v in next, ragebot do
			ragebot[k] = nil
		end

		for k, v in next, legitbot do
			legitbot[k] = nil
		end

		for k, v in next, misc do
			misc[k] = nil
		end

		for k, v in next, camera do
			camera[k] = nil
		end

		client = nil
		ragebot = nil
		legitbot = nil
		misc = nil
		camera = nil
		DeepRestoreTableFunctions = nil
	end

	local charcontainer = game.ReplicatedStorage.Character.BodyWIP
	local ghostchar = charcontainer.Ghost
	local phantomchar = charcontainer.Phantoms

	ragebot.repupdates = {}

	for _, player in next, Players:GetPlayers() do
		if player == LOCAL_PLAYER then
			continue
		end
		ragebot.repupdates[player] = {}
	end

	local ncf = CFrame.new()
	local vtos = ncf.VectorToObjectSpace

	local left = Vector3.new(1, 0, 0)
	local right = Vector3.new(-1, 0, 0)
	local forward = Vector3.new(0, 0, 1)
	local backward = Vector3.new(0, 0, -1)
	local up = Vector3.new(0, 1, 0)
	local down = Vector3.new(0, -1, 0)

	local directiontable = {
		left,
		right,
		forward,
		backward,
		up,
		down,
	}

	local mapRaycast = RaycastParams.new()
	mapRaycast.FilterType = Enum.RaycastFilterType.Whitelist
	mapRaycast.FilterDescendantsInstances = client.roundsystem.raycastwhitelist
	mapRaycast.IgnoreWater = true

	local uberpart = workspace:FindFirstChild("uber")

	if not uberpart then
		uberpart = Instance.new("Part", workspace)
		uberpart.Name = "uber"
		uberpart.Material = Enum.Material.Neon
		uberpart.Anchored = true
		uberpart.CanCollide = false
		uberpart.Size = Vector3.new(1, 1, 1)
	end

	client.localrank = client.rankcalculator(client.dirtyplayerdata.stats.experience)

	client.fakeplayer = Instance.new("Player", Players) -- thank A_003 for this (third person body)🔥
	client.fakeplayer.Team = LOCAL_PLAYER.Team
	client.removeplayer(client.fakeplayer) -- remove this moron from the leaderboard ez win
	debug.setupvalue(client.loadplayer, 1, client.fakeplayer)
	client.fake3pcharloaded = false
	client.loadplayer(LOCAL_PLAYER)
	client.fakeupdater = client.getupdater(LOCAL_PLAYER)
	if client.char.rootpart then
		-- client.fakerootpart.CFrame = client.char.rootpart.CFrame
		-- local rootpartpos = client.char.rootpart.Position

		local fakeupdaterupvals = debug.getupvalues(client.fakeupdater.step)
		fakeupdaterupvals[4].p = Vector3.new()
		fakeupdaterupvals[4].t = Vector3.new()
		fakeupdaterupvals[4].v = Vector3.new()
	end
	debug.setupvalue(client.loadplayer, 1, LOCAL_PLAYER)

	client.fakeplayer.Parent = nil
	-- do
	-- 	local updatervalues = getupvalues(client.fakeupdater.step)

	-- 	--[[updatervalues[11].s = 7
	-- 	updatervalues[15].s = 100]]
	-- 	client.fake_upvs = updatervalues
	-- 	table.foreach(client.fake_upvs, print)
	-- end

	local PLAYER_GUI = LOCAL_PLAYER.PlayerGui
	local CHAT_GAME = LOCAL_PLAYER.PlayerGui.ChatGame
	local CHAT_BOX = CHAT_GAME:FindFirstChild("TextBox")

	local OLD_GUNS = game:GetService("ReplicatedStorage").GunModules:Clone()
	OLD_GUNS.Name = tostring(math.random(1e5, 9e5))
	client.acchash = OLD_GUNS.Name
	OLD_GUNS.Parent = game:GetService("ReplicatedStorage")

	local CUR_GUNS = game:GetService("ReplicatedStorage").GunModules

	local loadplayer = client.loadplayer

	local function loadplayerhook(player)
		local newupdater = loadplayer(player)
		if newupdater then -- lazy fix...................
			local step = newupdater.step
			newupdater.step = function(what, what1)
				if not menu then
					return step(what, what1)
				else
					if menu:GetVal("Rage", "Aimbot", "Enabled") or menu:GetKey("Visuals", "Local", "Third Person")
					then
						return step(3, true)
					else
						return step(what, what1)
					end
				end
			end
		end
		return newupdater
	end

	CreateThread(function()
		local loadplayeridx = table.find(getupvalues(client.getupdater), loadplayer)

		if not loadplayeridx then
			for k, v in next, getupvalues(client.getupdater) do
				if type(v) == "function" then
					if v == loadplayer or getinfo(v).name == "loadplayer" then
						loadplayeridx = k
						break
					end
				end
			end

			if loadplayeridx then
				setupvalue(client.getupdater, loadplayeridx, loadplayerhook)
			else
				--warn("Unable to find loadplayer in getupdater")
			end
		end
	end)

	local selectedPlayer = nil

	local players = {
		Enemy = {},
		Team = {},
	}

	local mats = { "SmoothPlastic", "ForceField", "Neon", "Foil", "Glass" }
	local chatspams = {
		["lastchoice"] = 0,
		[1] = nil,
		[2] = {
			"BBOT ON TOP ",
			"BBOT ON TOP 🔥🔥🔥🔥",
			"BBot top i think ",
			"bbot > all ",
			"BBOT > ALL🧠 ",
			"WHAT SCRIPT IS THAT???? BBOT! ",
			"日工tch ",
			".gg/bbot",
		},
		[3] = {
			"but doctor prognosis: OWNED ",
			"but doctor results: 🔥",
			"looks like you need to talk to your doctor ",
			"speak to your doctor about this one ",
			"but analysis: PWNED ",
			"but diagnosis: OWND ",
		},
		[4] = {
			"音频少年公民记忆欲求无尽 heywe 僵尸强迫身体哑集中排水",
			"持有毁灭性的神经重景气游行脸红青铜色类别创意案",
			"诶比西迪伊艾弗吉艾尺艾杰开艾勒艾马艾娜哦屁吉吾",
			"完成与草屋两个苏巴完成与草屋两个苏巴完成与草屋",
			"庆崇你好我讨厌你愚蠢的母愚蠢的母庆崇",
			"坐下，一直保持着安静的状态。 谁把他拥有的东西给了他，所以他不那么爱欠债务，却拒��参加锻炼，这让他爱得更少了",
			", yīzhí bǎochízhe ānjìng de zhuàngtài. Shéi bǎ tā yǒngyǒu de dōngxī gěile tā, suǒyǐ tā bù nàme ài qiàn zhàiwù, què jùjué cānjiā duànliàn, z",
			"他，所以他不那r给了他东西给了他爱欠s，却拒绝参加锻炼，这让他爱得更UGT少了",
			"bbot 有的东西给了他，所以他不那rblx trader captain么有的东西给了他爱欠绝参加锻squidward炼，务，却拒绝参加锻炼，这让他爱得更UGT少了",
			"wocky slush他爱欠债了他他squilliam拥有的东西给爱欠绝参加锻squidward炼",
			"坐下，一直保持着安静的状态bbot 谁把他拥有的东西给了他，所以他不那rblx trader captain么有的东西给了他爱欠债了他他squilliam拥有的东西给爱欠绝参加锻squidward炼，务，却拒绝参加锻炼，这让他爱得更UGT少了",
			"免费手榴弹bbot hack绕过作弊工作Phantom Force roblox aimbot瞄准无声目标绕过2020工作真正免费下载和使用",
			"zal發明了roblox汽車貿易商的船長ro blocks，並將其洩漏到整個宇宙，還修補了虛假的角神模式和虛假的身體，還發明了基於速度的AUTOWALL和無限制的自動壁紙遊戲 ",
			"彼が誤って禁止されたためにファントムからautowallgamingを禁止解除する請願とそれはでたらめですそれはまったく意味がありませんなぜあなたは合法的なプレーヤーを禁止するのですか ",
			"ジェイソンは私が神に誓う女性的な男の子ではありません ",
			"傑森不是我向上帝發誓女性男孩 ",
		},
		[5] = {
			"🔥🔥🔥🔥🔥🔥🔥🔥",
			"😅😅😅😅😅😅😅😅",
			"😂😂😂😂😂😂😂😂",
			"😹😹😹😹😹😹😹😹",
			"😛😛😛😛😛😛😛😛",
			"🤩🤩🤩🤩🤩🤩🤩🤩",
			"🌈🌈🌈🌈🌈🌈🌈🌈",
			"😎😎😎😎😎😎😎😎",
			"🤠🤠🤠🤠🤠🤠🤠🤠",
			"😔😔😔😔😔😔😔😔",
		},
		[6] = {
			"gEt OuT oF tHe GrOuNd 🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡 ",
			"brb taking a nap 💤💤💤 ",
			"gonna go take a walk 🚶‍♂️🚶‍♀️🚶‍♂️🚶‍♀️ ",
			"low orbit ion cannon booting up ",
			"how does it feel to not have bbot 🤣🤣🤣😂😂😹😹😹 ",
			"im a firing my laza! 🙀🙀🙀 ",
			"😂😂😂😂😂GAMING CHAIR😂😂😂😂😂",
			"retardheadass",
			"can't hear you over these kill sounds ",
			"i'm just built different yo 🧱🧱🧱 ",
			"📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈",
			"OFF📈THE📈CHART📈",
			"KICK HIM 🦵🦵🦵",
			"THE AMOUNT THAT I CARE --> 🤏 ",
			"🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏",
			"SORRY I HURT YOUR ROBLOX EGO BUT LOOK -> 🤏 I DON'T CARE ",
			'table.find(charts, "any other script other than bbot") -> nil 💵💵💵',
			"LOL WHAT ARE YOU SHOOTING AT BRO ",
			"🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥",
			"BRO UR SHOOTING AT LIKE NOTHING LOL UR A CLOWN",
			"🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡",
			"ARE U USING EHUB? 🤡🤡🤡🤡🤡",
			"'EHUB IS THE BEST' 🤡 PASTED LINES OF CODE WITH UNREFERENCED AND UNINITIALIZED VARIABLES AND PEOPLE HAVE NO IDEA WHY IT'S NOT WORKING ",
			"LOL",
			"GIVE UP ",
			"GIVE UP BECAUSE YOU'RE NOT GOING TO BE ABLE TO KILL ME OR WIN LOL",
			"Can't hear you over these bands ",
			"I’m better than you in every way 🏆",
			"I’m smarter than you (I can verify this because I took an online IQ test and got 150) 🧠",
			"my personality shines and it’s generally better than your personality. Yours has flaws",
			"I’m more ambitious than you 🏆💰📣",
			"I’m more funny than you (long shot) ",
			"I’m less turbulent and more assertive and calm than you (proof) 🎰",
			"I’m stronger than you 💪 🦵 ",
			"my attention span is greater and better than yours (proven from you not reading entire list) ",
			"I am more creative and expressive than you will ever be 🎨 🖌️",
			"I’m a faster at typing than you 💬 ",
			"In 30 minutes, I will have lifted more weights than you can solve algebraic equations 📓 ",
			"By the time you have completed reading this very factual and groundbreaking evidence that I am truly more superior, thoughtful, and presentable than you are, I will have prospered (that means make negotiable currency or the American Dollar) more than your entire family hierarchy will have ever made in its time span 💰",
			"I am more seggsually stable and better looking than you are 👨",
			"I get along with women easier than you do 👩‍🚀", -- end
			"I am very good at debating 🗣️🧑‍⚖️ ",
			"I hit more head than you do 🏆", -- end
			"I win more hvh than you do 🏆", -- end yes this is actually how im going to fix this stupid shit
			"I am more victorious than you are 🏆",
			"Due to my agility, I am better than you at basketball, and all of your favorite sports or any sport for that matter (I will probably break your ankles in basketball by pure accident) ",
			"WE THE BEST CHEATS 🔥🔥🔥🔥 ",
			"Phantom Force Hack Unlook Gun And Aimbot ",
			"banlands 🔨 🗻 down 🏚️  ⏬ STOP CRASHING BANLANDS!! 🤣",
			"antares hack client isn't real ",
			"squidhook.xyz 🦑 ",
			"squidhook > all ",
			"spongehook 🤣🤣🤣💕",
			"retardheadass ",
			"interpolation DWORD* C++ int 32 bit programming F# c# coding",
			"Mad?",
			"are we in a library? 🤔 📚 cause you're 👉 in hush 🤫 mode 🤣 😂",
			"please help, my name is john escopetta, normally I would not do this, but under the circumstances I must ask for assistance, please send 500 United States dollars to my paypal, please",
			"🏀🏀 did i break your ankles brother ",
			"he has access to HACK SERVER AND CHANGE WEIGHTS!!!!! STOOOOOOP 😡😒😒😡😡😡😡😡",
			'"cmon dude don\'t use that" you asked for it LOL ',
			"ima just quit mid hvh 🚶‍♀️ ",
			"BABY 😭",
			"BOO HOO 😢😢😭😭😭 STOP CRYING D∪MBASS",
			"BOO HOO 😢😢😭😭😭 STOP CRYING ",
			"🤏",
			"🤏 <-- just to elaborate that i have no care for this situation or you at all, kid (not that you would understand anyways, you're too stupid to understand what i'm saying to begin with)",
			"y",
			"b",
			"before bbot 😭 📢				after bbot 😁😁😜					don't be like the person who doesn't have bbot",
			"							MADE YOU LOOK ",
			"							LOOK BRO LOOK LOOK AT ME ",
			"	A	",
			"			B		B		O		T	",
			"																																																																																																																								I HAVE AJAX YALL BETTER WATCH OUT OR YOU'LL DIE, WATCH WHO YOU'RE SHOOTING",
			"																																																																																																																								WATCH YOUR STEP KID",
			"BROOOO HE HAS																										GOD MODE BRO HE HAS GOD MODE 🚶‍♀️🚶‍♀️🚶‍♀️😜😂😂🤦‍♂️🤦‍♂️😭😭😭👶",
			'"guys what hub has auto shooting" 																										',
			"god i wish i had bbot..... 🙏🙏🥺🥺🥺													plzzzzz brooooo 🛐 GIVE IT🛐🛐",
			"buh bot 												",
			"votekick him!!!!!!! 😠 vk VK VK VK VOTEKICK HIM!!!!!!!!! 😠 😢 VOTE KICK !!!!! PRESS Y WHY DIDNT U PRESS Y LOL!!!!!! 😭 ", -- shufy made this
			"Bbot omg omggg omggg its BBot its BBOt OMGGG!!!  🙏🙏🥺🥺😌😒😡",
			"HOw do you get ACCESS to this BBOT ", -- end
			"I NEED ACCESS 🔑🔓 TO BBOT 🤖📃📃📃 👈 THIS THING CALLED BBOT SCRIPT, I NEED IT ",
			'"this god mode guy is annoying", Pr0blematicc says as he loses roblox hvh ',
			"you can call me crimson chin 🦹‍♂️🦹‍♂️ cause i turned your screen red 🟥🟥🟥🟥 									",
			"clipped that 🤡 ",
			"Clipped and Uploaded. 🤡",
			"nodus client slime castle crashers minecraft dupeing hack wizardhax xronize grief ... Tlcharger minecraft crack Oggi spiegheremo come creare un ip grabber!",
			"Off synonyme syls midge, smiled at mashup 2 mixed in key free download procom, ... Okay, love order and chaos online gameplayer hack amber forcen ahdistus",
			"ˢᵗᵃʸ ᵐᵃᵈ ˢᵗᵃʸ ᵇᵇᵒᵗˡᵉˢˢ $ ",
			"bbot does not relent ",
		},
	}
	--local
	-- "音频少年公民记忆欲求无尽 heywe 僵尸强迫身体哑集中排水",
	-- "持有毁灭性的神经重景气游行脸红青铜色类别创意案",
	-- "诶比西迪伊艾弗吉艾尺艾杰开艾勒艾马艾娜哦屁吉吾",
	-- "完成与草屋两个苏巴完成与草屋两个苏巴完成与草屋",
	-- "庆崇你好我讨厌你愚蠢的母愚蠢的母庆崇",
	local spam_words = { 
		"Hack", "Unlock", "Cheat", "Roblox", "Mod Menu", "Mod", "Menu", "God Mode", "Kill All", "Silent", "Silent Aim", "X Ray", "Aim", "Bypass", "Glitch", "Wallhack", "ESP", "Infinite", "Infinite Credits",
		"XP", "XP Hack", "Infinite Credits", "Unlook All", "Server Backdoor", "Serverside", "2021", "Working", "(WORKING)", "瞄准无声目标绕过", "Gamesense", "Onetap", "PF Exploit", "Phantom Force",
		"Cracked", "TP Hack", "PF MOD MENU", "DOWNLOAD", "Paste Bin", "download", "Download", "Teleport", "100% legit", "100%", "pro", "Professional", "灭性的神经",
		"No Virus All Clean", "No Survey", "No Ads", "Free", "Not Paid", "Real", "REAL 2020", "2020", "Real 2017", "BBot", "Cracked", "BBOT CRACKED by vw", "2014", "desuhook crack",
		"Aimware", "Hacks", "Cheats", "Exploits", "(FREE)", "🕶😎", "😎", "😂", "😛", "paste bin", "bbot script", "hard code", "正免费下载和使", "SERVER BACKDOOR",
		"Secret", "SECRET", "Unleaked", "Not Leaked", "Method", "Minecraft Steve", "Steve", "Minecraft", "Sponge Hook", "Squid Hook", "Script", "Squid Hack",
		"Sponge Hack", "(OP)", "Verified", "All Clean", "Program", "Hook", "有毁灭", "desu", "hook", "Gato Hack", "Blaze Hack", "Fuego Hack", "Nat Hook",
		"vw HACK", "Anti Votekick", "Speed", "Fly", "Big Head", "Knife Hack", "No Clip", "Auto", "Rapid Fire",
		"Fire Rate Hack", "Fire Rate", "God Mode", "God", "Speed Fly", "Cuteware", "Knife Range", "Infinite XRay", "Kill All", "Sigma", "And", "LEAKED",
		"🥳🥳🥳", "RELEASE", "IP RESOLVER", "Infinite Wall Bang", "Wall Bang", "Trickshot", "Sniper", "Wall Hack", "😍😍", "🤩", "🤑", "😱😱", "Free Download EHUB", "Taps", "Owns",
		"Owns All", "Trolling", "Troll", "Grief", "Kill", "弗吉艾尺艾杰开", "Nata", "Alan", "JSON", "BBOT Developers", "Logic", "And", "and", "Glitch", 
		"Server Hack", "Babies", "Children", "TAP", "Meme", "MEME", "Laugh", "LOL!", "Lol!", "ROFLSAUCE", "Rofl", ";p", ":D", "=D", "xD", "XD", "=>", "₽", "$", "8=>", "😹😹😹", "🎮🎮🎮", "🎱", "⭐", "✝", 
		"Ransomware", "Malware", "SKID", "Pasted vw", "Encrypted", "Brute Force", "Cheat Code", "Hack Code", ";v", "No Ban", "Bot", "Editing", "Modification", "injection", "Bypass Anti Cheat",
		"铜色类别创意", "Cheat Exploit", "Hitbox Expansion", "Cheating AI", "Auto Wall Shoot", "Konami Code", "Debug", "Debug Menu", "🗿", "£", "¥", "₽", "₭", "€", "₿", "Meow", "MEOW", "meow",
		"Under Age", "underage", "UNDER AGE", "18-", "not finite", "Left", "Right", "Up", "Down", "Left Right Up Down A B Start", "Noclip Cheat", "Bullet Check Bypass",
		"client.char:setbasewalkspeed(999) SPEED CHEAT.", "diff = dot(bulletpos, intersection - step_pos) / dot(bulletpos, bulletpos) * dt", "E = MC^2", "Beyond superstring theory", 
		"It is conceivable that the five superstring theories are approximated to a theory in higher dimensions possibly involving membranes.",
	}

	setrawmetatable(chatspams, { -- this is the dumbest shit i've ever fucking done
		__call = function(self, type, debounce, time)
			if type ~= 1 then
				if type == 7 or type == 9 then
					local words = type == 7 and spam_words or customChatSpam
					if #words == 0 then
						return nil
					end
					local message = ""
					for i = 1, math.random(25) do
						message = message .. " " .. words[math.random(#words)]
					end
					return message
				end
				local chatspamtype = type == 8 and customChatSpam or self[type]

				local rand = time and 1 + time % #chatspamtype or math.random(1, #chatspamtype)
				if not time and debounce then
					if self.lastchoice == rand then
						repeat
							rand = math.random(1, #chatspamtype)
						until rand ~= self.lastchoice
					end
					self.lastchoice = rand
				end
				local curchoice = chatspamtype[rand]
				return curchoice
			end
		end,
		__metatable = "neck yourself weird kid the fuck you trying to do",
	})

	local skelparts = { "Head", "Right Arm", "Right Leg", "Left Leg", "Left Arm" }

	local function MouseUnlockHook()
		if menu.open then
			if client.char.alive then
				INPUT_SERVICE.MouseBehavior = Enum.MouseBehavior.Default
			else
				INPUT_SERVICE.MouseIconEnabled = false
			end
		else
			if client.char.alive then
				INPUT_SERVICE.MouseBehavior = Enum.MouseBehavior.LockCenter
				INPUT_SERVICE.MouseIconEnabled = false
			else
				INPUT_SERVICE.MouseBehavior = Enum.MouseBehavior.Default
				INPUT_SERVICE.MouseIconEnabled = true
			end
		end
	end

	local function renderChams() -- this needs to be optimized a fucking lot i legit took this out and got 100 fps -- FUCK YOU JSON FROM MONTHS AGO YOU UDCK -- fuk json
		--debug.profilebegin("render chams")
		local PlayerList = Players:GetPlayers()
		for k = 1, #PlayerList do
			local player = PlayerList[k]
			if player == LOCAL_PLAYER then
				continue
			end -- doing this for now, i'll have to change the way the third person model will end up working
			local Body = client.replication.getbodyparts(player)
			if Body then
				local enabled
				local col
				local vTransparency

				local xqz
				local ivTransparency

				if player.Team ~= Players.LocalPlayer.Team then
					enabled = menu:GetVal("Visuals", "Enemy ESP", "Chams")
					col = menu:GetVal("Visuals", "Enemy ESP", "Chams", COLOR2, true)
					vTransparency = 1 - menu:GetVal("Visuals", "Enemy ESP", "Chams", COLOR2)[4] / 255
					xqz = menu:GetVal("Visuals", "Enemy ESP", "Chams", COLOR1, true)
					ivTransparency = 1 - menu:GetVal("Visuals", "Enemy ESP", "Chams", COLOR1)[4] / 255
				else
					enabled = menu:GetVal("Visuals", "Team ESP", "Chams")
					col = menu:GetVal("Visuals", "Team ESP", "Chams", COLOR2, true)
					vTransparency = 1 - menu:GetVal("Visuals", "Team ESP", "Chams", COLOR2)[4] / 255
					xqz = menu:GetVal("Visuals", "Team ESP", "Chams", COLOR1, true)
					ivTransparency = 1 - menu:GetVal("Visuals", "Team ESP", "Chams", COLOR1)[4] / 255
				end

				player.Character = Body.rootpart.Parent
				local Parts = player.Character:GetChildren()
				for k1 = 1, #Parts do
					Part = Parts[k1]
					--debug.profilebegin("renderChams " .. player.Name)
					if Part.ClassName ~= "Model" and Part.Name ~= "HumanoidRootPart" then
						local helmet = Part:FindFirstChild("HELMET")
						if helmet then
							helmet.Slot1.Transparency = enabled and 1 or 0
							helmet.Slot2.Transparency = enabled and 1 or 0
						end

						if not Part:FindFirstChild("c88") then
							for i = 0, 1 do
								local box

								if Part.Name ~= "Head" then
									box = Instance.new("BoxHandleAdornment", Part)
									box.Size = Part.Size + Vector3.new(0.1, 0.1, 0.1)
									if i == 0 then
										box.Size -= Vector3.new(0.25, 0.25, 0.25)
									end
									table.insert(misc.adornments, box)
								else
									box = Instance.new("CylinderHandleAdornment", Part)
									box.Height = Part.Size.y + 0.3
									box.Radius = Part.Size.x * 0.5 + 0.2
									if i == 0 then
										box.Height -= 0.2
										box.Radius -= 0.2
									end
									box.CFrame = CFrame.new(CACHED_VEC3, Vector3.new(0, 1, 0))
									table.insert(misc.adornments, box)
								end

								box.Name = i == 0 and "c88" or "c99"
								box.Adornee = Part
								box.ZIndex = 1

								box.AlwaysOnTop = i == 0 -- ternary sex
								box.Color3 = i == 0 and col or xqz
								box.Transparency = i == 0 and vTransparency or ivTransparency

								box.Visible = enabled
							end
						else
							for i = 0, 1 do
								local adorn = i == 0 and Part.c88 or Part.c99
								if menu:GetVal("Visuals", "ESP Settings", "Highlight Priority") and table.find(menu.priority, player.Name)
								then
									xqz = menu:GetVal(
											"Visuals",
											"ESP Settings",
											"Highlight Priority",
											COLOR,
											true
										)
									col = bColor:Mult(xqz, 0.6)
								elseif menu:GetVal("Visuals", "ESP Settings", "Highlight Friends", COLOR) and table.find(menu.friends, player.Name)
								then
									xqz = menu:GetVal("Visuals", "ESP Settings", "Highlight Friends", COLOR, true)
									col = bColor:Mult(xqz, 0.6)
								elseif menu:GetVal("Visuals", "ESP Settings", "Highlight Aimbot Target") and (
										player == legitbot.target or player == ragebot.target
									)
								then
									xqz = menu:GetVal(
										"Visuals",
										"ESP Settings",
										"Highlight Aimbot Target",
										COLOR,
										true
									)
									col = bColor:Mult(xqz, 0.6)
								end
								adorn.Color3 = i == 0 and col or xqz
								adorn.Visible = enabled
								adorn.Transparency = i == 0 and vTransparency or ivTransparency
							end
						end
					end
					--debug.profileend("renderChams " .. player.Name)
				end
			end
		end
		--debug.profileend("render chams")
	end

	local send = client.net.send
	local last_chat = os.time()

	CreateThread(function()
		repeat
			wait()
		until menu and menu.fading -- this is fucking bad
		while true do
			local current_time = os.time()
			if not menu then
				return
			end
			local speed = menu:GetVal("Misc", "Extra", "Chat Spam Delay")
			if current_time % speed == 0 and current_time ~= last_chat then
				local cs = menu:GetVal("Misc", "Extra", "Chat Spam")
				if cs ~= 1 then
					local curchoice = chatspams(cs, false, current_time)
					if curchoice ~= nil then
						curchoice = menu:GetVal("Misc", "Extra", "Chat Spam Repeat") and string.rep(curchoice, 100) or curchoice
						send(nil, "chatted", curchoice)
					end
				end
				last_chat = current_time
			end
			game.RunService.RenderStepped:Wait()
		end

		return
	end)

	do --ANCHOR metatable hookz
		local mt = getrawmetatable(game)

		local oldNewIndex = mt.__newindex
		local oldIndex = mt.__index
		local oldNamecall = mt.__namecall

		setreadonly(mt, false)

		mt.__newindex = newcclosure(function(self, id, val)
			if checkcaller() or not menu then
				return oldNewIndex(self, id, val)
			end
			if client.char.alive then
				if self == workspace.Camera then
					if id == "CFrame" then
						if menu:GetVal("Visuals", "Local", "Third Person") and menu:GetKey("Visuals", "Local", "Third Person") and client.char.alive
						then
							local dist = menu:GetVal("Visuals", "Local", "Third Person Distance") / 10
							local params = RaycastParams.new()
							params.FilterType = Enum.RaycastFilterType.Blacklist
							params.FilterDescendantsInstances = { Camera, workspace.Ignore, workspace.Players }

							local hit = workspace:Raycast(val.p, -val.LookVector * dist, params)
							if hit and not hit.Instance.CanCollide then
								return oldNewIndex(self, id, val * CFrame.new(0, 0, dist))
							end
							local mag = hit and (hit.Position - val.p).Magnitude or nil

							val *= CFrame.new(0, 0, mag or dist)
						end

						-- if keybindtoggles.superaa then
						-- 	local angles = val - val.p
						-- 	local newcf = client.superaastart * angles
						-- 	client.superaastart = newcf
						-- 	return oldNewIndex(self, id, newcf)
						-- end
					end
				elseif self == client.char.rootpart then
					if id == "CFrame" then
						-- if menu:GetVal("Misc", "Exploits", "Bypass Speed Checks") then
						-- 	oldNewIndex(self, id, LOCAL_MOUSE.Hit)
						-- 	oldNewIndex(self, "Position", LOCAL_MOUSE.Hit.p)
						-- 	oldNewIndex(self, "Velocity", Vector3.new(0, 0, 0))
						-- 	return 
						-- end
						-- if not keybindtoggles.superaa and menu:GetVal("Misc", "Exploits", "Noclip") and keybindtoggles.fakebody then -- yes this works i dont know why and im not assed to do this a different way but this is retarrded enough
						-- 	local offset = Vector3.new(0, client.fakeoffset, 0)
						-- 	self.Position = val.p - offset
						-- 	self.Position = val.p + offset
						-- end

						-- if keybindtoggles.superaa then
						-- 	-- Vector3.new(math.sin(tick() * 7) * 200, 50, math.cos(tick() * 7) * 100)
						-- 	client.superaastart = CFrame.new(client.superaastart.p)

						-- 	local tv = Vector3.new()
						-- 	local cf = client.cam.basecframe
						-- 	local rightVector = cf.RightVector
						-- 	local lv = cf.lookVector
						-- 	if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.W) then
						-- 		tv += lv
						-- 	end
						-- 	if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.S) then
						-- 		tv -= lv
						-- 	end
						-- 	if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.A) then
						-- 		tv -= rightVector
						-- 	end
						-- 	if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.D) then
						-- 		tv += rightVector
						-- 	end
						-- 	if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.Space) then
						-- 		tv += Vector3.new(0, 1, 0)
						-- 	end
						-- 	if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftShift) then
						-- 		tv -= Vector3.new(0, 1, 0)
						-- 	end

						-- 	local shouldAdd = tv.Unit.x == tv.Unit.x
						-- 	local hitwall = false
						-- 	if shouldAdd then
						-- 		local unit = tv.Unit
						-- 		unit *= 0.01
						-- 		local nextpos = client.superaastart + unit * menu:GetVal("Misc", "Movement", "Fly Speed")
						-- 		local delta = nextpos.p - client.superaastart.p
						-- 		local raycastResult = workspace:Raycast(client.superaastart.p, delta, mapRaycast)
						-- 		if raycastResult then
						-- 			--warn("HITTING A WALL")
						-- 			hitwall = true
						-- 			local hitpos = raycastResult.Position
						-- 			local normal = raycastResult.Normal
						-- 			local newpos = hitpos + 0.1 * normal
						-- 			client.superaastart = CFrame.new(newpos)
						-- 		end
						-- 		if not hitwall then
						-- 			client.superaastart += unit * menu:GetVal("Misc", "Movement", "Fly Speed")
						-- 		end
						-- 	end

						-- 	local supervector = Vector3.new((os.time() * 850) % 6000, 50, math.cos(os.time() * 5) * 6900)
						-- 	local uber = client.superaastart.p + supervector
						-- 	oldNewIndex(self, id, client.superaastart)
						-- 	oldNewIndex(self, "Position", uber)
						-- 	oldNewIndex(self, "Velocity", Vector3.new(0, 0, 0))
						-- 	return
						-- end
					end
				end
			end
			return oldNewIndex(self, id, val)
		end)

		mt.__namecall = newcclosure(function(self, ...)
			if not checkcaller() then
				local namecallmethod = getnamecallmethod()
				local fkunate = { ... }
				if self == workspace and namecallmethod == "FindPartsInRegion3" then
					if menu.spectating then
						-- sphereraycast cheat 2021
						fkunate[2] = workspace.CurrentCamera
					end
					return oldNamecall(self, unpack(fkunate))
				end
			end

			return oldNamecall(self, ...)
		end)

		menu.oldmt = {
			__newindex = oldNewIndex,
			__index = oldIndex,
			__namecall = oldNamecall,
		}

		setreadonly(mt, true)
	end

	do --ANCHOR camera function definitions.
		function camera:SetArmsVisible(flag)
			local larm, rarm = Camera:FindFirstChild("Left Arm"), Camera:FindFirstChild("Right Arm")
			assert(larm, "arms are missing")
			for k, v in next, larm:GetChildren() do
				if v:IsA("Part") then
					v.Transparency = flag and 0 or 1
				end
			end
			for k, v in next, rarm:GetChildren() do
				if v:IsA("Part") then
					v.Transparency = flag and 0 or 1
				end
			end
		end

		function camera:GetFOV(Part, originPart) originPart = originPart or workspace.Camera
			local directional = CFrame.new(originPart.CFrame.Position, Part.Position)
			local ang = Vector3.new(directional:ToOrientation()) - Vector3.new(originPart.CFrame:ToOrientation())
			return math.deg(ang.Magnitude)
		end

		function camera:GetPlayersOrganizedByFov(players)
			local result = {}
			local playerobjects = {}
			players = players or Players:GetPlayers()
			for i, player in next, players do
				local curbodyparts = client.replication.getbodyparts(player)
				if curbodyparts and client.hud:isplayeralive(player) then
					local fov = camera:GetFOV(curbodyparts.rootpart)
					result[i] = fov
				else
					result[i] = 999
				end
			end
			table.sort(result)
			for i, fov in next, result do
				playerobjects[fov] = players[i]
			end
			return playerobjects
		end

		function camera:IsVisible(Part, origin) origin = origin or Camera.CFrame.Position

			local hit, position = workspace:FindPartOnRayWithWhitelist(Ray.new(origin, Part.Position - origin), client.roundsystem.raycastwhitelist)

			if hit then
				if hit.CanCollide and hit.Transparency == 0 then
					return false
				else
					return self:IsVisible(Part, position + (Part.Position - origin).Unit * 0.01)
				end
			else
				return true
			end

			-- return (position == Part.Position or (Parent and hit and Parent:IsAncestorOf(hit)))
		end

		function camera:LookAt(pos)
			local angles = camera:GetAnglesTo(pos, true)
			local delta = client.cam.angles - angles
			client.cam.angles = angles
			client.cam.delta = delta
		end

		function camera:GetAngles()
			local pitch, yaw = Camera.CFrame:ToOrientation()
			return { ["pitch"] = pitch, ["yaw"] = yaw, ["x"] = pitch, ["y"] = yaw }
		end

		function camera:GetAnglesTo(Pos, useVector)
			local pitch, yaw = CFrame.new(Camera.CFrame.Position, Pos):ToOrientation()
			if useVector then
				return Vector3.new(pitch, yaw, 0)
			else
				return { ["pitch"] = pitch, ["yaw"] = yaw }
			end
		end

		function camera:GetTrajectory(pos, origin)
			if client.logic.currentgun and client.logic.currentgun.data then origin = origin or Camera.CFrame.Position
				local traj = client.trajectory(origin, GRAVITY, pos, client.logic.currentgun.data.bulletspeed)
				return traj and origin + traj or false
			end
		end
	end

	do --ANCHOR ragebot definitions
		ragebot.sprint = true
		ragebot.shooting = false
		ragebot.predictedDamageDealt = {}
		ragebot.predictedDamageDealtRemovals = {}
		ragebot.predictedMisses = {}
		ragebot.predictedShotAt = {}
		ragebot.fakePositionsResolved = {}
		ragebot.firsttarget = nil
		ragebot.spin = 0
		ragebot.angles = Vector2.new(0, 0)
		do
			local function GetPartTable(ply)
				local tbl = {}
				for k, v in pairs(ply) do
					tbl[v] = true
				end
				return tbl
			end
		end

		local timehit = client.physics.timehit

		local function isdirtyfloat(f) -- if we dont use this theres a large chance the autowall will break
			local dirtyflag = true -- that being said this function is actually useful, pretty much a QNAN check or whatever
			if f == f then
				dirtyflag = true
				if f ~= (1 / 0) then
					dirtyflag = f == (-1 / 0)
				end
			end
			return dirtyflag
		end

		local bulletLifeTime = client.publicsettings.bulletLifeTime

		local function ignorecheck(p)
			if p.Name == "abcdefg" then
				return false
			end
			if not p.CanCollide then
				return true
			end
			if p.Transparency == 1 then
				return true
			end
			if p.Name ~= "Window" then
				return
			end
			return true
		end

		local dot = Vector3.new().Dot

		local bulletcheckresolution = 0.03333333333333333

		function ragebot.bulletcheck(origin, dest, velocity, acceleration, penetration, whitelist) -- reversed
			local ignorelist = { workspace.Terrain, workspace.Players, workspace.Ignore, workspace.CurrentCamera }
			local bullettime = 0
			local exited = false
			local penetrated = true
			local step_pos = origin
			local penetration = penetration
			local intersection
			local maxtime = timehit(step_pos, velocity, acceleration, dest)
			if not (not isdirtyfloat(maxtime)) or bulletLifeTime < maxtime or maxtime == 0 then
				return false
			end
			while bullettime < maxtime do
				local dt = maxtime - bullettime
				if dt > bulletcheckresolution then
					dt = bulletcheckresolution
				end
				local bulletvelocity = dt * velocity + dt * dt / 2 * acceleration
				local enter = raycastutil.raycast(step_pos, bulletvelocity, ignorelist, ignorecheck, true)
				if enter then
					local hit = enter.Instance
					if enter.Position then
						intersection = enter.Position
					end
					local normalized = bulletvelocity.unit
					if whitelist and whitelist[hit] then
						penetrated = true
						step_pos = intersection
						break
					end
					local exit = raycastutil.raycastSingleExit(intersection, hit.Size.magnitude * normalized, hit)
					if exit then
						local norm = exit.Normal
						local dist = dot(normalized, exit.Position - intersection)
						local diff = dot(bulletvelocity, intersection - step_pos) / dot(bulletvelocity, bulletvelocity)  * dt
						step_pos = intersection + 0.01 * normalized
						velocity = velocity + diff * acceleration
						bullettime = bullettime + diff
						if not (dist < penetration) then
							penetrated = false
							break
						end
						penetration = penetration - dist
						table.insert(ignorelist, hit)
						exited = true
					else
						step_pos = step_pos + bulletvelocity
						velocity = velocity + dt * acceleration
						bullettime = bullettime + dt
					end
				else
					step_pos = step_pos + bulletvelocity
					velocity = velocity + dt * acceleration
					bullettime = bullettime + dt
				end
			end

			return penetrated, exited, step_pos
		end

		function ragebot:GetResolvedPosition(player, curbodyparts)
			if not menu:GetVal("Rage", "Settings", "Resolve Fake Positions") then return end
			local resolvedPosition
			local misses = self.predictedMisses[player]
			local modmisses = misses and misses % 5

			curbodyparts = curbodyparts or client.replication.getbodyparts(player)
			if not curbodyparts or not client.hud:isplayeralive(player) or not curbodyparts.torso then
				return
			end
			local rep = ragebot.repupdates[player] 
			if rep and rep.position and rep.position and (rep.position - curbodyparts.torso.Position).Magnitude > 18  then
				resolvedPosition = rep.position
			end
			if (curbodyparts.rootpart.Position - curbodyparts.torso.Position).Magnitude > 18 then
				resolvedPosition = curbodyparts.rootpart.Position
			end
			if modmisses and modmisses > 3 then
				local rep = self.fakePositionsResolved[player]
				
				if rep and (rep - curbodyparts.torso.Position).Magnitude > 18 then
					resolvedPosition = rep
				end
			end
			
			return resolvedPosition
		end

		function ragebot:GetDamage(distance, headshot)
			local data = client.logic.currentgun.data
			local r0, r1, d0, d1 = data.range0, data.range1, data.damage0, data.damage1
			return (
					distance < r0 and d0 or distance < r1 and (d1 - d0) / (r1 - r0) * (distance - r0) + d0 or d1
				)  * (headshot and data.multhead or 1)
		end

		function ragebot:bulletcheck_legacy(origin, destination, penetration, whitelist)
			local dir = (destination - origin)
			if dot(dir, dir) < 0 then
				return true
			end

			local hit, enter = workspace:FindPartOnRayWithWhitelist(Ray.new(origin, dir), client.roundsystem.raycastwhitelist)

			if hit then
				local unit = dir.Unit
				local maxextent = hit.Size.Magnitude * unit
				local _, exit = workspace:FindPartOnRayWithWhitelist(Ray.new(enter + maxextent, -maxextent), { hit })
				local diff = exit - enter
				local dist = dot(unit, diff)
				if dist < 0 then
					return true
				end
				local pass = not hit.CanCollide or hit.Name == "Window" or hit.Transparency == 1
				local exited = false

				local newpos = enter + 0.01 * unit

				if not pass then
					if dist < penetration then
						penetration = penetration - dist
					else
						return false
					end
				end

				return ragebot:bulletcheck_legacy(newpos, destination, penetration, whitelist)
			else
				return true
			end
		end

		function ragebot:CanPenetrate(origin, target, penetration, whitelist)
			if not whitelist then
				whitelist = { [target] = true }
			end
			local autowallchoice = menu:GetVal("Rage", "Aimbot", "Auto Wall")
			if autowallchoice ~= 1 and autowallchoice == 2 then
				local d, t = client.trajectory(origin, GRAVITY, target.Position, client.logic.currentgun.data.bulletspeed)
				if not t then
					return
				end
				if not d then
					return ragebot:bulletcheck_legacy(origin, target.Position, penetration, whitelist)
				end
				local z = d.Unit * client.logic.currentgun.data.bulletspeed -- bullet speed cheat --PATCHED. :(
				-- bulletcheck dumps if you fucking do origin + traj idk why you do it but i didnt do it and it fixed the dumping
				return ragebot.bulletcheck(origin, target.Position, z, GRAVITY, penetration, whitelist)
			else
				return ragebot:bulletcheck_legacy(origin, target.Position, penetration, whitelist)
			end
		end

		function ragebot:AimAtTarget(part, target, head, origin, resolved, backtrack_frame)
			local origin = origin or client.cam.cframe.p
			if not part then
				ragebot.silentVector = nil
				ragebot.firepos = nil
				--[[ if ragebot.shooting and menu:GetVal("Rage", "Aimbot", "Auto Shoot") then
					client.logic.currentgun:shoot(false)
				end ]]
				ragebot.target = nil
				ragebot.shooting = false
				return
			end

			local position = (backtrack_frame and backtrack_frame.pos) or (part and part.Position)
			local target_pos = position
			local dist = (position - origin).Magnitude
			local dir = camera:GetTrajectory(position, origin) - origin
			if not menu:GetVal("Rage", "Aimbot", "Silent Aim") then
				camera:LookAt(dir + origin)
			end
			ragebot.silentVector = dir.unit
			ragebot.target = target
			ragebot.targetpart = part
			ragebot.firepos = origin
			ragebot.shooting = true
			ragebot.time = (backtrack_frame and backtrack_frame.time) or tick()
			if menu:GetVal("Rage", "Aimbot", "Auto Shoot") then
				local firerate = type(client.logic.currentgun.data.firerate) == "table" and client.logic.currentgun.data.firerate[1] or client.logic.currentgun.data.firerate
				local scaledFirerate = firerate  * menu:GetVal("Misc", "Weapon Modifications", "Fire Rate Scale") / 100
				local damage = self:GetDamage(dist, head)
				damage *= client.logic.currentgun.data.pelletcount or 1 -- super shotgun cheat
				ragebot:shoot(scaledFirerate, target, damage)
				misc.autopeekposition = nil
			end
		end

		local HITBOX_SHIFT_SIZE = Vector3.new(3, 3, 3)
		local HITBOX_SHIFT_AMOUNT = 12.5833333333333
		local lastHitboxPriority
		ragebot.backtrackframes = {}

		function ragebot:GetBacktrackedPosition(player, curbodyparts, time)
			if not self.backtrackframes[player] then
				self.backtrackframes[player] = {}
			end
			local newframe = {pos = curbodyparts.rootpart.Position, time = tick()}
			if not self.backtrackframes[player][1] or (newframe.pos - self.backtrackframes[player][#self.backtrackframes[player]].pos).Magnitude > 1 then
				table.insert(self.backtrackframes[player], newframe)
			end

			for i = #self.backtrackframes[player], 1, -1  do
				if not self.backtrackframes[player][i] then continue end
				if tick() - self.backtrackframes[player][i].time > time - GetLatency() * 2 then
					table.remove(self.backtrackframes[player], i)
				end 
			end
			return self.backtrackframes[player][1]
		end
		function ragebot:GetTarget(hitboxPriority, players, origin)
			hitboxPriority = hitboxPriority == 1 and "head" or "torso"
			hitboxPriority = hitboxPriority or lastHitboxPriority
			lastHitboxPriority = hitboxPriority or lastHitboxPriority
			self.intersection = nil

			--debug.profilebegin("BB self GetTarget")
			--local hitscan = hitscan or {}
			local partPreference = hitboxPriority
				or "you know who i am? well you about to find out, your barbecue boy"
			local closest, cpart, theplayer = math.huge, nil, nil
			if not players then
				players = { self.firsttarget, table.unpack(Players:GetPlayers()) } --= this is so much fucking ebtter but it's still ultra shit
			end

			local autowall = menu:GetVal("Rage", "Aimbot", "Auto Wall")
			local aw_resolve = menu:GetVal("Rage", "Hack vs. Hack", "Autowall Hitscan")
			local hitboxshift = menu:GetVal("Rage", "Hack vs. Hack", "Hitbox Shifting")
			--local campos = client.cam.basecframe
			local zerocf = client.cam.basecframe - client.cam.basecframe.p
			local campos = origin or zerocf + client.lastrepupdate
			local camposreal = campos
			local camposv3 = camposreal.p
			local firepos
			local head
			local resolvedPosition
			local newbone
			local realbone
			local backtrackFrame 

			local aimbotFov = menu:GetVal("Rage", "Aimbot", "Aimbot FOV")
			for usingbacktrack = 0, 1 do
				if cpart and usingbacktrack == 1 then break end
				for i, player in next, players do
					if player.Team ~= LOCAL_PLAYER.Team and player ~= LOCAL_PLAYER then
						if table.find(menu.friends, player.Name) and menu:GetVal("Misc", "Extra", "Ignore Friends") then
							continue
						end
						if
							not table.find(menu.priority, player.Name)
							and menu:GetVal("Misc", "Extra", "Target Only Priority Players")
						then
							continue
						end
						if
							menu:GetVal("Rage", "Settings", "Aimbot Damage Prediction")
							and self.predictedDamageDealt[player]
							and self.predictedDamageDealt[player] > menu:GetVal("Rage", "Settings", "Damage Prediction Limit")
						then
							continue
						end
						local misses = self.predictedMisses[player] or 1
						local curbodyparts = client.replication.getbodyparts(player)
						if curbodyparts and client.hud:isplayeralive(player) then
							local newhitboxshift = hitboxshift
							resolvedPosition = self:GetResolvedPosition(player, curbodyparts)
							local resolved = false

							if resolvedPosition then
								menu.parts.resolverHitbox.Position = resolvedPosition
								resolved = true
								newhitboxshift = false
							end
							local backtracked, backtrackpart
							if not resolved then
								if menu:GetVal("Rage", "Hack vs. Hack", "Backtracking") and usingbacktrack == 1 then
									backtrackFrame = self:GetBacktrackedPosition(player, curbodyparts, menu:GetVal("Rage", "Hack vs. Hack", "Backtracking Time")/1000 / (client.stutterFrames % 2 == 1 and 2 or 1))
									
									if backtrackFrame and backtrackFrame.pos then
										newhitboxshift = false
										backtracked = true
										time = backtrackFrame.time
										backtrackpart = menu.parts.backtrackHitbox
										backtrackpart.Position = backtrackFrame.pos
									end
								end
							end
							local bone = curbodyparts.rootpart
							realbone = curbodyparts[hitboxPriority]
							if bone.ClassName == "Part" then
								local newbone = realbone
								if resolved then
									newbone = menu.parts.resolverHitbox
									self.intersection = menu.parts.resolverHitbox.Position
								elseif backtracked then
									newbone = backtrackpart
									self.intersection = backtrackpart.Position
								end
								local fovToBone = camera:GetFOV(newbone)
								if fovToBone < aimbotFov or aimbotFov > 180 then -- Awesome
									if camera:IsVisible(newbone, camposv3) then
										if fovToBone < closest then
											closest = fovToBone
											cpart = bone
											theplayer = player
											firepos = camposv3
											head = hitboxPriority == "head"
											if menu.priority[player.Name] then
												break
											end
										else
											continue
										end
									elseif autowall ~= 1 then
										--debug.profilebegin("BB self Penetration Check " .. player.Name)
										local directionVector = camera:GetTrajectory(newbone.Position, camposv3)
										-- self:CanPenetrate(LOCAL_PLAYER, player, directionVector, newbone.Position, barrel, menu:GetVal("Rage", "Hack vs. Hack", "Extend Penetration"))
										-- self:CanPenetrate(origin, target, velocity, penetration)
										if not directionVector then
											continue
										end
										if
										self:CanPenetrate(
												camposv3,
												newbone,
												client.logic.currentgun.data.penetrationdepth
											)
										then
											cpart = realbone
											theplayer = player
											firepos = camposv3
											head = hitboxPriority == "head"
											if menu.priority[player.Name] then
												break
											end
										elseif aw_resolve then
											local axisPosition, bulletintersection =
												self:HitscanOnAxes(camposreal, player, newbone, newhitboxshift)
											if axisPosition then
												self.firepos = axisPosition
												cpart = realbone
												theplayer = player
												firepos = axisPosition
												head = hitboxPriority == "head"
												if menu.priority[player.Name] then
													break
												end
											end
										end
										--debug.profileend("BB self Penetration Check " .. player.Name)
									end
								end
							end
						end
					end
				end
			end
			if
				(cpart and theplayer and closest and firepos)
				and menu:GetKey("Misc", "Exploits", "Crimwalk")
				and menu:GetVal("Misc", "Exploits", "Disable Crimwalk on Shot")
			then
				menu:SetKey("Misc", "Exploits", "Crimwalk")
				CreateNotification("Crimwalk disabled due to ragebot")
				LOCAL_PLAYER.Character.HumanoidRootPart.Position = client.lastrepupdate
			end
			--debug.profileend("BB self GetTarget")
			
			return cpart, theplayer, closest, firepos, head, backtrackFrame
		end

		function ragebot:GetKnifeTargets()
			local results = {}

			for i, ply in ipairs(Players:GetPlayers()) do
				if table.find(menu.friends, ply.Name) and menu:GetVal("Misc", "Extra", "Ignore Friends") then
					continue
				end
				if not table.find(menu.priority, ply.Name) and menu:GetVal("Misc", "Extra", "Target Only Priority Players")
				then
					continue
				end

				if ply.Team ~= LOCAL_PLAYER.Team and client.hud:isplayeralive(ply) then
					local parts = client.replication.getbodyparts(ply)
					if not parts then
						continue
					end

					local target_pos = parts.rootpart.Position
					local target_direction = target_pos - client.cam.cframe.p
					local target_dist = (target_pos - client.cam.cframe.p).Magnitude
					local ignore = { LOCAL_PLAYER, Camera, workspace.Ignore, workspace.Players }

					local part1, ray_pos = workspace:FindPartOnRayWithIgnoreList(Ray.new(client.cam.cframe.p, target_direction), ignore)
					local part2, ray_pos = workspace:FindPartOnRayWithIgnoreList(
							Ray.new(client.cam.cframe.p - Vector3.new(0, 2, 0), target_direction),
							ignore
						)

					local ray_distance = (target_pos - ray_pos).Magnitude
					table.insert(results, {
						player = ply,
						part = parts.head,
						tppos = ray_pos,
						direction = target_direction,
						dist = target_dist,
						insight = ray_distance < 15 and part1 == part2,
					})
				end
			end

			return results
		end

		function ragebot:KnifeBotMain()
			if not client.char.alive then
				return
			end
			if not LOCAL_PLAYER.Character or not LOCAL_PLAYER.Character:FindFirstChild("HumanoidRootPart") then
				return
			end

			if menu:GetVal("Rage", "Extra", "Knife Bot") and menu:GetKey("Rage", "Extra", "Knife Bot", true) then
				local knifetype = menu:GetVal("Rage", "Extra", "Knife Bot Type")
				if knifetype == 2 then
					ragebot:KnifeAura()
				elseif knifetype == 3 then
					ragebot:FlightAura()
				end
			end
		end

		function ragebot:FlightAura()
			local targets = ragebot:GetKnifeTargets()

			for i, target in pairs(targets) do
				if not target.insight then
					continue
				end
				LOCAL_PLAYER.Character.HumanoidRootPart.Anchored = false
				LOCAL_PLAYER.Character.HumanoidRootPart.Velocity = target.direction.Unit * 130

				return ragebot:KnifeAura(targets)
			end
		end

		function ragebot:KnifeAura(t)
			local targets = t or ragebot:GetKnifeTargets()
			for i, target in ipairs(targets) do
				if target.player then
					ragebot:KnifeTarget(target)
				end
			end
		end

		function ragebot:KnifeTarget(target, stab)
			if target and target.part then 
				local cfc = client.cam.cframe
				--send(client.net, "repupdate", cfc.p, client.cam.angles) -- Makes knife aura work with anti nade tp
				if stab then
					send(client.net, "stab")
				end
				local newhit = nil
				newhit = { Name = target.part.Name, Position = client.cam.cframe.p } -- fuckin hack
				send(client.net, "knifehit", target.player, tick(), newhit or target.part)
			end
		end

		function ragebot:GetCubicMultipoints(origin, extent)
			assert(extent % 2 == 0, "extent value must be even")
			local start = origin or client.cam.basecframe.p
			local max_step = extent or 8

			start -= Vector3.new(max_step, -max_step, max_step) / 2

			local pos = start
			local half = max_step / 2

			local points = { corner = table.create(8), inside = table.create(19) }

			for x = 0, max_step do
				for y = 0, -max_step, -1 do
					for z = 0, max_step do
						local isPositionCorner = x % max_step == 0 and y % max_step == 0 and z % max_step == 0
						local isPositionInside = x % half == 0 and y % half == 0 and z % half == 0
						if isPositionCorner then
							pos = start + Vector3.new(x, y, z)

							table.insert(points.corner, 1, pos)
						elseif isPositionInside then
							pos = start + Vector3.new(x, y, z)

							table.insert(points.inside, 1, pos)
						end
					end
				end
			end

			return points
		end

		function ragebot:CubicHitscan(studs, origin, selectedpart) -- Scans in a cubic square area of size (studs) and resolves a position to hit target at
			assert(
				studs,
				"what are you trying to do young man, this is illegal.  you do know that you have to provide us with shit to use to calculate this, you do realize this right?"
			) -- end
			assert( origin,
				"just like before, we need information to even apply this to our things we made to provide you with ease of p100 hits 🤡"
			)
			assert(
				selectedpart,
				"what are you attempting to do what the fuck are you dumb?? you are just testing my patience"
			) -- end

			local dapointz = ragebot:GetCubicMultipoints(origin, studs or 18 * 2)

			local pos
			-- ragebot:CanPenetrate(origin, target, velocity, penetration)
			for i, point in pairs(dapointz.corner) do
				local penetrated = ragebot:CanPenetrate(point, selectedpart, client.logic.currentgun.data.penetrationdepth)

				if penetrated then
					pos = point
					return
				end
			end

			if pos then
				return pos
			end

			for i, point in pairs(dapointz.inside) do
				local penetrated = ragebot:CanPenetrate(point, selectedpart, client.logic.currentgun.data.penetrationdepth)

				if penetrated then
					pos = point
					return
				end
			end

			if pos then
				return pos
			end

			return nil
		end

		local hitscanPoints = { 0, 0, 0, 0, 0, 0, 0, 0 }
		local hitboxShiftPoints = { 0, 0, 0, 0, 0 }
		local hitboxShiftAmount = { 0, 0 }
		if BBOT.username == "dev" then
			StatMenuRendered:connect(function(text)
				text.Text ..= string.format("\n--menu-- %d %d %d", menu.inmenu and 1 or 0, menu.inmiddlemenu and 1 or 0, menu.intabs and 1 or 0)
				text.Text ..= string.format("\n--hitscan-- %d %d %d %d %d %d %d %d", unpack(hitscanPoints))
				text.Text ..= string.format("\n--hitbox shift method-- %d %d %d %d %d", unpack(hitboxShiftPoints))
				text.Text ..= string.format("\n--hitbox-- %d %d", unpack(hitboxShiftAmount))
				text.Text ..= string.format("\n--smart legitbot-- %0.1f", legitbot.smart)
				text.Text ..= ("%s %s %s"):format(menu.inmenu and "true" or "false", menu.inmiddlemenu and "true" or "false", menu.intabs and "true" or "false")
				if ragebot.lasthittick and ragebot.lasthittime then
					text.Text ..= string.format("\n--backtracking-- %dms", (ragebot.lasthittick - ragebot.lasthittime) * 1000)
				end
				if misc.normalPositive and misc.speedDirection then
					text.Text ..= string.format("\n--avoid collisions-- %0.2f %0.2f %0.2f %0.2f", misc.normalPositive, misc.normal.x, misc.normal.y, misc.normal.z)
					text.Text ..= string.format("\n--circle strafe-- %0.2f %0.2f", misc.speedDirection.x, misc.speedDirection.z)
				end
			end)
		end
		local shiftmode = 1
		local shiftmodes = {
			function(part, position)
				return (part.Position - position).Unit
			end,
			function(part, position)
				return part.Velocity.Unit
			end,
			function(part, position)
				return -part.Velocity.Unit
			end,
			function(part, position, localpart)
				return localpart.Velocity.Unit
			end,
			function(part, position, localpart)
				return -localpart.Velocity.Unit
			end
		}
		-- local function GetHitBoxShift(person, bodypart, position)
		-- 	local misses = ragebot.predictedMisses[person] or 0
		-- 	local HITBOX_SHIFT_TOTAL = menu:GetVal("Rage", "Hack vs. Hack", "Hitbox Shift Distance")
		-- 	local HITBOX_SHIFT_AMOUNT = HITBOX_SHIFT_TOTAL / 2
		-- 	local pullAmount =
		-- 		clamp((HITBOX_SHIFT_AMOUNT - HITBOX_SHIFT_AMOUNT * misses / 10), 2, HITBOX_SHIFT_AMOUNT)
		-- 	local shiftSize = clamp(HITBOX_SHIFT_AMOUNT - misses, 1, HITBOX_SHIFT_AMOUNT)
		-- 	local pullVector = (bodypart.Position - position).Unit * pullAmount
		-- 	local newTargetPosition = bodypart.Position - pullVector
		-- 	menu.parts.sphereHitbox.Size = Vector3.new(shiftSize, shiftSize, shiftSize)
		-- 	menu.parts.sphereHitbox.Position = newTargetPosition -- ho. ly. fu. cking. shit,.,m
		-- 	hitboxShiftAmount[1] = shiftSize
		-- 	hitboxShiftAmount[2] = pullAmount
		-- 	return menu.parts.sphereHitbox, { [menu.parts.sphereHitbox] = true }, pullAmount, shiftSize
		-- end

		
		local function GetHitBoxShift(person, bodypart, position)
			shiftmode += 1
			shiftmode %= #shiftmodes
			shiftmode += 1
			local misses = ragebot.predictedMisses[person] or 0
			local HITBOX_SHIFT_TOTAL = menu:GetVal("Rage", "Hack vs. Hack", "Hitbox Shift Distance")
			local HITBOX_SHIFT_AMOUNT = HITBOX_SHIFT_TOTAL / 2
			local HITBOX_SHIFT_SIZE = HITBOX_SHIFT_AMOUNT
			local pullAmount = clamp((HITBOX_SHIFT_AMOUNT - HITBOX_SHIFT_AMOUNT * misses / 10), 1, HITBOX_SHIFT_AMOUNT)
			local shiftSize = clamp(HITBOX_SHIFT_AMOUNT - misses, 1, HITBOX_SHIFT_AMOUNT)
			local pullVector = shiftmodes[shiftmode](bodypart, position, LOCAL_PLAYER.Character.HumanoidRootPart) * pullAmount
			local newTargetPosition = bodypart.Position - pullVector
			
			menu.parts.sphereHitbox.Size = Vector3.new(shiftSize, shiftSize, shiftSize)
			menu.parts.sphereHitbox.Position = newTargetPosition -- ho. ly. fu. cking. shit,.,m
			hitboxShiftAmount[1] = shiftSize
			hitboxShiftAmount[2] = pullAmount
			return menu.parts.sphereHitbox, { [menu.parts.sphereHitbox] = true }, shiftmode
		end
		
		function ragebot:HitscanOnAxes(origin, person, bodypart, hitboxshift)
			local step = 9.5
			local hitscanOffsets = {
				CFrame.new(0, step, 0),
				CFrame.new(0, -step, 0),
				CFrame.new(-step, 0, 0),
				CFrame.new(step, 0, 0),
				CFrame.new(0, 0, -step),
				CFrame.new(0, 0, step),
				CFrame.new(),
			}
			local whitelist = { [bodypart] = true }
			assert(bodypart, "hello")

			local dest = typeof(bodypart) ~= "Vector3" and bodypart.Position or bodypart -- fuck

			assert(person, "something went wrong in your nasa rocket launch")
			assert(typeof(origin) == "CFrame", "what are you trying to do young man") -- end

			local maxPoints = client.aliveplayers
					and math.ceil(menu:GetVal("Rage", "Settings", "Max Hitscan Points") / client.aliveplayers)
				or #hitscanOffsets
			-- ragebot:CanPenetrateRaycast(barrel, bone.Position, client.logic.currentgun.data.penetrationdepth, true, menu.parts.sphereHitbox)
			-- for k, v in next, hitscanPoints do
			-- 	print(k, v)
			-- end
			local resolverPoints = menu:GetVal("Rage", "Hack vs. Hack", "Hitscan Points")
			if resolverPoints[8] then
				local position = origin
				local pull = (bodypart.Position - position.p).Unit * step
				position = position.p + pull
				local hitbox = bodypart
				local shifttype
				if hitboxshift then
					hitbox, whitelist, shifttype = GetHitBoxShift(person, bodypart, position)
				end
				local pen, exited, bulletintersection =
					ragebot:CanPenetrate(position, hitbox, client.logic.currentgun.data.penetrationdepth, whitelist)

				if pen then
					hitscanPoints[8] += 1
					if shifttype then
						hitboxShiftPoints[shifttype] += 1
					end
					return position, bulletintersection
				end
			end
			for i = 1, math.min(#hitscanOffsets, maxPoints) do -- this makes it skip if ur using low max Hitscan Points rofl suace super fast speed cheat :)
				if resolverPoints[i] == true then -- this is so that it doesn't skip for the origin point
					local position = origin * hitscanOffsets[i]
					local hitbox = bodypart
					local shifttype
					if hitboxshift then
						hitbox, whitelist, shifttype = GetHitBoxShift(person, bodypart, position.p)
					end
					local pen, exited, bulletintersection =
						ragebot:CanPenetrate(position.p, hitbox, client.logic.currentgun.data.penetrationdepth, whitelist)
					if pen then
						hitscanPoints[i] += 1
						if shifttype then
							hitboxShiftPoints[shifttype] += 1
						end
						return position.p, bulletintersection
					else
						position = origin
					end
				end
			end

			return nil
		end

		function ragebot:MainLoop() -- lfg
			ragebot.silentVector = nil
			local prioritizedpart = menu:GetVal("Rage", "Aimbot", "Hitscan Priority")

			ragebot:Stance()
			if menu:GetVal("Rage", "Fake Lag", "Enabled") and not menu:GetVal("Rage", "Fake Lag", "Manual Choke")
			then
				if (not client.fakelagpos or not client.fakelagtime) or ((client.cam.cframe.p - client.fakelagpos).Magnitude > menu:GetVal("Rage", "Fake Lag", "Fake Lag Distance") or tick() - client.fakelagtime > 1) or not client.char.alive
				then
					if client.char.alive then
						client.fakelagtime = tick()
						client.fakelagpos = client.cam.cframe.p
					end
					NETWORK:SetOutgoingKBPSLimit(0)
					ragebot.choking = false
				else
					ragebot.choking = true
					NETWORK:SetOutgoingKBPSLimit(menu:GetVal("Rage", "Fake Lag", "Fake Lag Amount"))
				end
			else
			end

			

			if client.char.alive and menu:GetVal("Rage", "Aimbot", "Enabled") and menu:GetKey("Rage", "Aimbot", "Enabled", true)
			then
				if client.logic.currentgun and client.logic.currentgun.type ~= "KNIFE" then -- client.loogic.poop.falsified_directional_componenet = Vector8.new(math.huge) [don't fuck with us]
					if ragebot:LogicAllowed() then
						local playerlist = Players:GetPlayers()

						if not client then
							return
						end
						local priority_list = {}
						for k, PlayerName in pairs(menu.priority) do
							if Players:FindFirstChild(PlayerName) then
								table.insert(priority_list, game.Players[PlayerName])
							end
						end
						local targetPart, targetPlayer, fov, firepos, head, backtrackFrame = ragebot:GetTarget(prioritizedpart, priority_list)
						if not targetPart and not menu:GetVal("Misc", "Extra", "Target Only Priority Players") then
							targetPart, targetPlayer, fov, firepos, head, backtrackFrame = ragebot:GetTarget(prioritizedpart, playerlist)
						end
						ragebot:AimAtTarget(targetPart, targetPlayer, head, firepos, resolved, backtrackFrame)
					end
				else
					self.target = nil
				end
			end
		end

		ragebot.stance = "prone"
		ragebot.sprint = false
		ragebot.stancetick = tick()
		function ragebot:Stance()
			if LOCAL_PLAYER.Character and LOCAL_PLAYER.Character:FindFirstChild("Humanoid") then
				if menu:GetVal("Rage", "Anti Aim", "Hide in Floor") and menu:GetVal("Rage", "Anti Aim", "Enabled") and not LOCAL_PLAYER.Character.Humanoid.Jump
				then
					LOCAL_PLAYER.Character.Humanoid.HipHeight = -1.9
				else
					LOCAL_PLAYER.Character.Humanoid.HipHeight = 0
				end
			end
			if menu:GetVal("Rage", "Anti Aim", "Enabled") then
				if (tick() - ragebot.stancetick) >= 0.5 then
					ragebot.stancetick = tick()
					local stanceId = menu:GetVal("Rage", "Anti Aim", "Force Stance")
					if stanceId ~= 1 then
						newStance =  --ternary sex/
							stanceId == 2 and "stand" or stanceId == 3 and "crouch" or stanceId == 4 and "prone"
						ragebot.stance = newStance
						send(client.net, "stance", newStance)
					end
					if menu:GetVal("Rage", "Anti Aim", "Lower Arms") then
						ragebot.sprint = true
						send(nil, "sprint", true)
					end
					if menu:GetVal("Rage", "Anti Aim", "Tilt Neck") then
						ragebot.tilt = true
						send(nil, "aim", true)
					end
				end
			end
		end
	end

	local _3pweps = {}

	do
		local VirtualUser = game:GetService("VirtualUser")
		menu.connections.local_player_id_connect = LOCAL_PLAYER.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)

		local oldmag = client.cam.setmagnification
		local oldmenufov = client.cam.changemenufov
		client.cam.changemenufov = function(...)
			if menu and menu.open then
				return
			end
			oldmenufov(...)
		end
		local magspeed = 1
		client.cam.magspring.s = 1
		-- local mt = {__index = function(self, i) if i == "s" then return magspeed or 1 end end, __newindex = function(self, i, v) if i == "s" then magspeed = v end end}
		-- setrawmetatable(client.cam.magspring, mt)
		client.cam.setmagnification = function(self, m)
			local lnm = math.log(m)
			if menu and menu:GetVal("Visuals", "Camera Visuals", "Disable ADS FOV") then
				if lnm > self.magspring.p then
					return
				end -- THIS IS SOFUCKING DUMB LOL
			end
			self.magspring.p = lnm
			self.magspring.t = lnm
			self.magspring.v = 0
		end
		client.cam.setmagnificationspeed = function(self, s)
			self.magspring.s = s
		end

		local shake = client.cam.shake
		client.cam.shake = function(self, magnitude)
			if menu and menu:GetVal("Visuals", "Camera Visuals", "Reduce Camera Recoil") then
				local scale = 1 - menu:GetVal("Visuals", "Camera Visuals", "Camera Recoil Reduction") * 0.01
				magnitude *= scale
			end
			return shake(client.cam, magnitude)
		end

		local suppress = client.cam.suppress
		client.cam.suppress = function(...)
			if menu and menu:GetVal("Visuals", "Camera Visuals", "No Visual Suppression") then
				return
			end
			return suppress(...)
		end

		local setscope = client.hud.setscope

		function client.hud:setscope(vis, nosway)
			isPlayerScoped = vis
			setscope(self, vis, nosway)
		end

		-- client event hooks! for grenade paths... and other shit (idk where to put this)/
		
		local clienteventfuncs = getupvalue(client.call, 1)

		local function create_outlined_square(pos, destroydelay, colordata)
			local newpart = Instance.new("Part", workspace)
			newpart.CanCollide = false
			newpart.Anchored = true
			newpart.Size = Vector3.new(0.35, 0.35, 0.35)
			newpart.Position = pos
			newpart.Material = Enum.Material.Neon
			newpart.Transparency = 0.85

			local colors = colordata or { Color3.fromRGB(255, 255, 255), Color3.fromRGB(239, 62, 62) }

			for i = 1, 2 do
				local box = Instance.new("BoxHandleAdornment", newpart)
				box.AlwaysOnTop = true
				box.Adornee = box.Parent
				box.ZIndex = i == 1 and 5 or 1
				box.Color3 = i == 1 and colors[1] or colors[2]
				box.Size = i == 1 and newpart.Size / 1.3 or newpart.Size * 1.3
				box.Transparency = i == 1 and 0 or 0.3
				table.insert(misc.adornments, box)
			end

			debris:AddItem(newpart, destroydelay)
		end

		local function create_line(origin_att, ending_att, destroydelay) -- pasting this from the misc create beam but oh well im a faggot so yeah :troll:
			local beam = Instance.new("Beam")
			beam.LightEmission = 1
			beam.LightInfluence = 1
			beam.Enabled = true
			beam.Color = ColorSequence.new(menu:GetVal("Visuals", "Dropped ESP", "Grenade ESP", COLOR2, true))
			beam.Attachment0 = origin_att
			beam.Attachment1 = ending_att
			beam.Width0 = 0.2
			beam.Width1 = 0.2

			beam.Parent = workspace

			debris:AddItem(beam, destroydelay)
			debris:AddItem(origin_att, destroydelay)
			debris:AddItem(ending_att, destroydelay)
		end
		if client.sound then
			-- local playsound = client.sound.PlaySound
			-- client.sound.PlaySound = function(...)
			-- 	local args = { ... }
			-- 	if menu and menu:GetVal("Misc", "Extra", "Disable Team Sounds") then
			-- 		if args[1]:match("friendly") then
			-- 			return 
			-- 		end
			-- 		if args[1]:match("equip[A-Z]") then
			-- 			return
			-- 		end
			-- 	end
			-- 	-- if menu and menu:GetVal("Misc", "Extra", "Disable Team Sounds") then
			-- 	-- else
			-- 	return playsound(unpack(args))
			-- 	-- end
			-- end
		end
		
		for hash, func in next, clienteventfuncs do
			local curconstants = getconstants(func)
			local found = table.find(curconstants, "Trigger")
			local found1 = table.find(curconstants, "removecharacterhash")
			local found2 = getinfo(func).name == "swapgun"
			local found3 = table.find(curconstants, "updatecharacter")
			local found4 = getinfo(func).name == "swapknife"
			local found5 = table.find(curconstants, "Votekick ")
			local found6 = table.find(curconstants, " studs")
			local found7 = table.find(curconstants, "setstance")
			local found8 = table.find(curconstants, "setfixedcam")
			local found9 = table.find(curconstants, "kickweapon")
			local found10 = table.find(curconstants, "equip")
			local found11 = table.find(curconstants, "equipknife")
			local found12 = table.find(curconstants, "setlookangles")
			local found13 = table.find(curconstants, "Msg")
			local found14 = table.find(curconstants, "[Console]: ")

			if found then
				clienteventfuncs[hash] = function(thrower, gtype, gdata, displaytrail)
					if gdata.blowuptime > 0 and thrower.team ~= LOCAL_PLAYER.Team or thrower == LOCAL_PLAYER then
						local lastrealpos
						
						local frames = gdata.frames
						local blowup, st = gdata.blowuptime, gdata.time
						local inc = 0.016666666666666666
						
						local curtick = tick()
						local dst = st - curtick
						local realtime = curtick + dst * (st + blowup - curtick) / (blowup + dst)
						local err = realtime - curtick
						
						local j = 1
						
						for dt = 0, blowup / inc do
							local t = inc * dt
							
							do
								local realtime = tick() + t
								local time = realtime + dst * (st + blowup - realtime) / (blowup + dst)
								
								local rtnext = tick() + (inc * (dt + 1))
								local next_time = rtnext + dst * (st + blowup - rtnext) / (blowup + dst)
								
								local frame = frames[j]
								local nextframe = j + 1 <= #frames and frames[j + 1] or nil
								
								if nextframe and time > st + nextframe.t0 then
									j += 1
									frame = nextframe
								end
								
								local t = time - (st + frame.t0)
								local next_t = next_time - (st + frame.t0)
								
								local pos = frame.p0 + t * frame.v0 + t * t / 2 * frame.a + frame.offset
								local nextpos = frame.p0 + next_t * frame.v0 + next_t * next_t / 2 * frame.a + frame.offset
								--local rot = client.cframe.fromaxisangle(t * frame.rotv) * frame.rot0
								lastrealpos = pos
								
								if menu:GetVal("Visuals", "Dropped ESP", "Grenade ESP") then
									local c1 = menu:GetVal("Visuals", "Dropped ESP", "Grenade ESP", COLOR1, true)
									local c2 = menu:GetVal("Visuals", "Dropped ESP", "Grenade ESP", COLOR2, true)
									local colorz = {c1, c2}
									if nextpos then
										--local mag = (nextpos - pos).magnitude
										-- magnitude stuff wont work because the line will just end for no reason
										create_outlined_square(pos, blowup, colorz)
										local a1 = Instance.new("Attachment", workspace.Terrain)
										a1.Position = pos
										local a2 = Instance.new("Attachment", workspace.Terrain)
										a2.Position = nextpos
										
										create_line(a1, a2, blowup, colorz)
									else
										create_outlined_square(pos, blowup, colorz)
									end
								end
							end
						end
						
						if menu:GetVal("Visuals", "Dropped ESP", "Grenade Warning") then
							local btick = curtick + (math.abs((curtick + gdata.blowuptime) - curtick) - math.abs(err))
							if curtick < btick then
								table.insert(menu.activenades, {
									thrower = thrower.Name,
									blowupat = lastrealpos,
									blowuptick = btick, -- might need to be tested more
									start = curtick
								})
							end
						end
					end
					return func(thrower, gtype, gdata, displaytrail)
				end
			end
			if found1 then
				clienteventfuncs[hash] = function(charhash, bodyparts)
					local modparts = bodyparts
					for k, v in next, modparts:GetChildren() do
						if not v:IsA("Model") and not v:IsA("Humanoid") then
							v.Size = bodysize[v.Name] -- reset the ragdolls to their defaulted size defined at bodysize, in case of hitbox expansion
						end
					end
					return func(charhash, modparts)
				end
			end
			if found3 then
				clienteventfuncs[hash] = function(player, parts)
					if player.Team ~= LOCAL_PLAYER.Team then
						for k, v in next, parts:GetChildren() do
							if v:IsA("Part") then
								local formattedval = (
										menu:GetVal("Legit", "Aim Assist", "Enlarge Enemy Hitboxes") / 95
									) + 1
								v.Size *= v.Name == "Head" and Vector3.new(formattedval, v.Size.y * (1 + formattedval / 100), formattedval) or formattedval -- hitbox expander
							end
						end
					end
					return func(player, parts)
				end
			end
			if found5 then
				clienteventfuncs[hash] = function(name, countdown, endtick, reqs)
					func(name, countdown, endtick, reqs)
					local friends = menu:GetVal("Misc", "Extra", "Vote Friends")
					local priority = menu:GetVal("Misc", "Extra", "Vote Priority")
					local default = menu:GetVal("Misc", "Extra", "Default Vote")
					
					if name == LOCAL_PLAYER.Name then
						client.hud:vote("no")
					else
						if table.find(menu.friends, name) and friends ~= 1 then
							local choice = friends == 2 and "yes" or "no"
							client.hud:vote(choice)
						end
						if table.find(menu.priority, name) and priority ~= 1 then
							local choice = priority == 2 and "yes" or "no"
							client.hud:vote(choice)
						end
						if default ~= 1 then
							local choice = default == 2 and "yes" or "no"
							client.hud:vote(choice)
						end
					end
				end
			end

			if found6 then
				clienteventfuncs[hash] = function(killer, victim, dist, weapon, head)
					if killer == LOCAL_PLAYER and victim ~= LOCAL_PLAYER then
						if menu:GetVal("Misc", "Extra", "Kill Sound") then
							local soundid = menu:GetVal("Misc", "Extra", "killsoundid")
							local soundEmpty = soundid == ""
							soundid = soundEmpty and "rbxassetid://6229978482" or soundid

							if not soundEmpty then
								local isSoundPath = soundid:match("%D+") or false
								if isSoundPath then
									if not soundid:match("^rbxassetid://") then
										local validPath = isfile(soundid)
										if validPath then
											soundid = getsynasset(soundid)
										end
									end
								else
									local shit = soundid:match("%d+")
									soundid = string.format("rbxassetid://%d", shit)
								end
							end

							client.sound.PlaySoundId(
								soundid,
								menu:GetVal("Misc", "Extra", "Kill Sound Volume") / 10,
								1.0,
								workspace,
								nil,
								0,
								0.03
							)
						end
						if menu:GetVal("Misc", "Extra", "Kill Say") then
							local killsay = menu.lastkillsay
							while killsay == menu.lastkillsay do
								killsay = math.random(#customKillSay)
							end
							menu.lastkillsay = killsay
							local message = customKillSay[killsay]
							message = message:gsub("%[hitbox%]", head and "head" or "body")
							message = message:gsub("%[name%]", victim.Name)
							message = message:gsub("%[weapon%]", weapon)
							client.net:send("chatted", message)
						end
					end

					if victim ~= LOCAL_PLAYER then
						if victim == ragebot.firsttarget then
							ragebot.firsttarget = nil
						end
						-- if not ragebot.repupdates[victim] then
						-- 	printconsole("Unable to find position data for " .. victim.Name)
						-- end
						ragebot.backtrackframes[victim] = {}
						ragebot.repupdates[victim] = {}
						ragebot.fakePositionsResolved[victim] = nil
					else
						if ragebot then
							ragebot.predictedDamageDealt = table.create(Players.MaxPlayers)
							ragebot.predictedDamageDealtRemovals = table.create(Players.MaxPlayers)
							ragebot.firsttarget = killer
						end
					end
					ragebot.predictedDamageDealt[victim] = 0
					ragebot.predictedMisses[victim] = 0
					ragebot.predictedDamageDealtRemovals[victim] = nil
					return func(killer, victim, dist, weapon, head)
				end
			end
			if found7 then
				clienteventfuncs[hash] = function(player, newstance)
					local chosenstance = newstance
					if menu and menu.GetVal then
						local ting = menu:GetVal("Rage", "Hack vs. Hack", "Force Player Stances")
						local choice = menu:GetVal("Rage", "Hack vs. Hack", "Stance Choice")
						choice = choice == 1 and "stand" or choice == 2 and "crouch" or "prone"
						chosenstance = ting and choice or newstance
					end
					return func(player, chosenstance)
				end
			end
			if found8 then
				clienteventfuncs[hash] = function(...)
					local args = { ... }

					if menu:GetVal("Misc", "Extra", "Auto Martyrdom") then
						local fragargs = {
							"FRAG",
							{
								frames = {
									{
										v0 = Vector3.new(),
										glassbreaks = {},
										t0 = 0,
										offset = Vector3.new(0 / 0, 0 / 0, 0 / 0),
										rot0 = CFrame.new(),
										a = Vector3.new(0, -80, 0),
										p0 = client.lastrepupdate or client.char.head.Position,
										rotv = Vector3.new(),
									},
								},
								time = tick(),
								curi = 1,
								blowuptime = 0.2,
							},
						}
						for i = 1, 3 do
							send(nil, "newgrenade", unpack(fragargs))
						end
					end

					return func(...)
				end
			end
			if found9 then
				clienteventfuncs[hash] = function(bulletdata)
					ragebot.fakePositionsResolved[bulletdata.player] = bulletdata.firepos
					local misses = ragebot.predictedMisses[bulletdata.player]
					-- if misses and misses > 16 then
					-- 	ragebot.predictedMisses[bulletdata.player] = 5
					-- end
					local vec = Vector3.new()
					for k, bullet in next, bulletdata.bullets do
						if typeof(bullet) ~= "Vector3" then
							bulletdata.bullets[k][1] = vec
						end
					end

					if typeof(bulletdata.firepos) ~= "Vector3" then
						bulletdata.firepos = vec
					end

					return func(bulletdata)
				end
			end
			if found10 then
				clienteventfuncs[hash] = function(player, weapon, camodata, attachments)
					_3pweps[player] = weapon
					return func(player, weapon, camodata, attachments)
				end
			end
			if found11 then
				clienteventfuncs[hash] = function(player, weapon, camodata)
					_3pweps[player] = weapon
					return func(player, weapon, camodata)
				end
			end
			if found12 then
				clienteventfuncs[hash] = function(player, newangles)
					local bodyparts = client.replication.getbodyparts(player)
					if bodyparts and type(bodyparts) == "table" then
						local pos = bodyparts.rootpart.Position
						ragebot.repupdates[player] = {
							["position"] = pos,
							["tick"] = tick(),
						}
					end

					if newangles.Magnitude >= 2 ^ 10 then
						return
					end
					return func(player, newangles)
				end
			end
			if found13 then
				clienteventfuncs[hash] = function(chatter, text, tag, tagcolor, teamchat, chattername)
					if menu.muted[chatter.Name] then
						return
					end
					if table.find(menu.annoylist, chatter.Name) and not text:find("gay") then -- lel
						send(nil, "chatted", text)
					end
					return func(chatter, text, tag, tagcolor, teamchat, chattername)
				end
				if found2 then
					clienteventfuncs[hash] = function(gun, mag, spare, attachdata, camodata, gunn, ggequip)
						func(gun, mag, spare, attachdata, camodata, gunn, ggequip)
						if client.fakecharacter then
							client.fakeupdater.equip(
								require(game:service("ReplicatedStorage").GunModules[gun]),
								game:service("ReplicatedStorage").ExternalModels[gun]:Clone()
							)
						end
					end
				end
			end
			if found14 then
				client.console = func
				local console_upvs = getupvalues(func)
				client.bbconsole = function(txt, name)
					name = name or "bitchbot"
					local misc = game.ReplicatedStorage.Misc
					local chatgui = console_upvs[4].Parent

					local msg = console_upvs[2]
					local message = msg:Clone()
					local tag = message.Tag
					local offset = 5

					message.Parent = chatgui.GlobalChat
					message.Text = "[" .. name .. "]: "
					message.Msg.Text = txt
					message.Msg.Position = UDim2.new(0, message.TextBounds.x, 0, 0)
					message.Visible = true
					message.Msg.Visible = true

					CreateThread(function()
						while message.Parent == chatgui.GlobalChat do
							message.TextColor3 = RGB(unpack(menu.mc))
							game.RunService.RenderStepped:Wait()
						end
					end)
				end
			end
		end
	end

	do
		local tween = game:service("TweenService")

		client.closecast = require(game.ReplicatedFirst.SharedModules.Utilities.Geometry.CloseCast)
		local partnames = { "head", "torso", "lleg", "rleg", "larm", "rarm" }
		local partexpansionarray = { 0.75, 1.5, 1.5, 1.5, 1.5, 1.5 }

		local nv = Vector3.new()
		local dot = nv.Dot

		local bodyarrayinfo = getupvalue(client.replication.thickcastplayers, 7)
		local chartable = getupvalue(client.replication.getallparts, 1)
		client.chartable = chartable

		function client.thickcastplayers(origin, direction) -- i might attempt to use this on bulletcheck later
			local castresults = nil
			for player, bodyparts in next, chartable do
				local delta = bodyparts.torso.Position - origin
				local directiondot = dot(direction, direction)
				local diff = dot(direction, delta)
				if diff > 0 and diff < directiondot and directiondot * dot(delta, delta) - diff * diff < directiondot * 6 * 6
				then
					for i = 1, #partnames do
						local maxdist = 0.0425 -- regular on pc with controller is just this
						--[[if lol then
							if i == 1 then
								maxexpansion = lol / 2
							else
								maxexpansion = lol
							end
						elseif partexpansionarray then
							maxexpansion = partexpansionarray[i]
						end]]
						maxdist = partexpansionarray[i]
						local curbodypart = bodyparts[partnames[i]]
						local pos, what, hitpos, dist = closecast.closeCastPart(curbodypart, origin, direction)
						if pos and dist < maxdist then
							if not castresults then
								castresults = {}
							end
							castresults[#castresults + 1] = {
								bodyarrayinfo[curbodypart],
								curbodypart,
								hitpos,
								(what - hitpos).unit,
								what,
								dist, 
							}
							break
						end
					end
				end
			end
			return castresults
		end
		--keybind connection shit
		client.char.ondied:connect(function()
			if misc then
				misc:BypassSpeedCheck(false)
				-- misc:Invisibility(true)
			end
		end)
		misc.beams = {}
		function misc:CreateBeam(origin_att, ending_att, texture)
			local beam = Instance.new("Beam")
			beam.Texture = texture or "http://www.roblox.com/asset/?id=446111271"
			beam.TextureMode = Enum.TextureMode.Wrap
			beam.TextureSpeed = 8
			beam.LightEmission = 1
			beam.LightInfluence = 1
			beam.TextureLength = 12
			beam.FaceCamera = true
			beam.Enabled = true
			beam.ZOffset = -1
			beam.Transparency = NumberSequence.new(0,0)
			beam.Color = ColorSequence.new(menu:GetVal("Visuals", "Misc", "Bullet Tracers", COLOR, true), Color3.new(0, 0, 0))
			beam.Attachment0 = origin_att
			beam.Attachment1 = ending_att
			debris:AddItem(beam, 3)
			debris:AddItem(origin_att, 3)
			debris:AddItem(ending_att, 3)

			local speedtween = TweenInfo.new(5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
			tween:Create(beam, speedtween, { TextureSpeed = 2 }):Play()
			beam.Parent = workspace
			table.insert(misc.beams, { beam = beam, time = tick() })
			return beam
		end

		function misc:UpdateBeams()
			local time = tick()
			for i = #self.beams, 1, -1 do
				if self.beams[i].beam  then
					local transparency = (time - self.beams[i].time) - 2
					self.beams[i].beam.Transparency = NumberSequence.new(transparency, transparency)
				else
					table.remove(self.beams, i)
				end
			end
		end
		
		function misc:BypassSpeedCheck(val)
			local char = LOCAL_PLAYER.Character
			if not char then return end
			local rootpart = char:FindFirstChild("HumanoidRootPart")
			if not rootpart then
				return
			end
			rootpart.Anchored = false
			self.oldroot = rootpart

			if val and client.char.alive and not self.newroot then
				copy = rootpart:Clone()
				copy.Parent = char
				self.newroot = copy
			elseif self.newroot then
				if ((not val) or (not client.logic.currentgun) or (not client.char.alive) or (not client.menu.isdeployed())) then
					self.newroot:Destroy()
					self.newroot = nil
				else
					-- client.char.rootpart.CFrame = self.newroot.CFrame
					--idk if i can manipulate this at all
				end
			end
		end


		function misc:Invisibility(val)
			local char = LOCAL_PLAYER.Character
			local rootpart = char:FindFirstChild("HumanoidRootPart")
			if not rootpart then
				return
			end
			if self.invisroot then
				self.invisroot:Destroy()
				self.invisroot = nil
				for k, v in next, self.invisparts do
					v:Destroy()
				end
				for k, v in next, self.invismodel:children() do
					v.Parent = char
				end
				self.invisparts = nil
				return CreateNotification("Disabled Invisibility")
			end

			if val then
				return
			end
			if not self.invismodel then self.invismodel = Instance.new("Model", workspace) end
			if not self.invisparts then self.invisparts = {} end
			self.teleporting = false

			local cf = rootpart.CFrame
			local hv = rootpart.Velocity
			rootpart.Anchored = false
			rootpart.Velocity = Vector3.new(0, 9e2, 0)
			rootpart.CFrame = cf + Vector3.new(0, 9e2, 0)

			self.teleporting = true

			wait(0.2)
			for k, v in next, char:GetChildren() do
				if v ~= rootpart and v:IsA("BasePart") then
					local copy = v:Clone()
					self.invisparts[k] = copy
					v.Parent = self.invismodel
					copy.Parent = char
				end
			end
			for k, v in next, self.invismodel:children() do
				v.CFrame += Vector3.new(-math.huge, -math.huge, -math.huge)
				v.Velocity = Vector3.new(-math.huge, -math.huge, -math.huge)
			end
			copy = rootpart:Clone()
			rootpart.CFrame += Vector3.new(9e9, 9e9, 9e9)
			rootpart.Velocity = Vector3.new(9e9, 9e9, 9e9)
			copy.Parent = char

			wait(0.2)

			self.teleporting = false

			copy.Velocity = Vector3.new()
			copy.CFrame = cf
			self.invisroot = copy
			self.oldroot = rootpart
			client.cam.shakecframe = CFrame.new()
			return CreateNotification("Enabled Invisibility")
		end


		function misc:RapidKill()
			local team = LOCAL_PLAYER.Team.Name == "Phantoms" and game.Teams.Ghosts or game.Teams.Phantoms
			local i = 1
			local nadesent = false
			for k, v in next, team:GetPlayers() do
				if client.logic.gammo <= 0 then
					break
				end
				if table.find(menu.priority, v.Name) and client.hud:isplayeralive(v) then
					local curbodyparts = client.replication.getbodyparts(v)
					if not curbodyparts then
						return
					end
					local chosenpos = math.abs((curbodyparts.rootpart.Position - curbodyparts.torso.Position).Magnitude) > 10 and curbodyparts.rootpart.Position or curbodyparts.head.Position
					local args = {
						"FRAG",
						{
							frames = {
								{
									v0 = Vector3.new(),
									glassbreaks = {},
									t0 = 0,
									offset = Vector3.new(),
									rot0 = CFrame.new(),
									a = Vector3.new(0 / 0),
									p0 = client.lastrepupdate or client.char.head.Position,
									rotv = Vector3.new(),
								},
								{
									v0 = Vector3.new(),
									glassbreaks = {},
									t0 = 0.002,
									offset = Vector3.new(),
									rot0 = CFrame.new(),
									a = Vector3.new(0 / 0),
									p0 = Vector3.new(0 / 0),
									rotv = Vector3.new(),
								},
								{
									v0 = Vector3.new(),
									glassbreaks = {},
									t0 = 0.003,
									offset = Vector3.new(),
									rot0 = CFrame.new(),
									a = Vector3.new(),
									p0 = chosenpos + Vector3.new(0, 3, 0),
									rotv = Vector3.new(),
								},
							},
							time = tick(),
							blowuptime = 0.003,
						},
					}

					send(client.net, "newgrenade", unpack(args))
					nadesent = true
					client.logic.gammo -= 1
					client.hud:updateammo("GRENADE")
				end
			end
			for k, v in next, team:GetPlayers() do
				if client.logic.gammo <= 0 then
					break
				end
				if not (
						table.find(menu.friends, v.Name) and menu:GetVal("Misc", "Extra", "Ignore Friends")
					) and client.hud:isplayeralive(v)
				then
					if not table.find(menu.friends, v.Name) and menu:GetVal("Misc", "Extra", "Target Only Priority Players")
					then
						continue
					end
					local curbodyparts = client.replication.getbodyparts(v)
					if not curbodyparts then
						return
					end
					local chosenpos = math.abs((curbodyparts.rootpart.Position - curbodyparts.torso.Position).Magnitude) > 10 and curbodyparts.rootpart.Position or curbodyparts.head.Position
					local args = {
						"FRAG",
						{
							frames = {
								{
									v0 = Vector3.new(),
									glassbreaks = {},
									t0 = 0,
									offset = Vector3.new(),
									rot0 = CFrame.new(),
									a = Vector3.new(0 / 0),
									p0 = client.lastrepupdate or client.char.head.Position,
									rotv = Vector3.new(),
								},
								{
									v0 = Vector3.new(),
									glassbreaks = {},
									t0 = 0.002,
									offset = Vector3.new(),
									rot0 = CFrame.new(),
									a = Vector3.new(0 / 0),
									p0 = Vector3.new(0 / 0),
									rotv = Vector3.new(),
								},
								{
									v0 = Vector3.new(),
									glassbreaks = {},
									t0 = 0.003,
									offset = Vector3.new(),
									rot0 = CFrame.new(),
									a = Vector3.new(),
									p0 = chosenpos + Vector3.new(0, 3, 0),
									rotv = Vector3.new(),
								},
							},
							time = tick(),
							blowuptime = 0.003,
						},
					}

					send(client.net, "newgrenade", unpack(args))
					client.logic.gammo -= 1
					nadesent = true
					client.hud:updateammo("GRENADE")
				end
			end

			return client.logic.gammo <= 0
		end

		function misc:Teleport(newpos)
			if not client.char.alive then return end
			local rootparts = { LOCAL_PLAYER.Character and client.char.rootpart, self.invisroot, self.newroot }
			local start = Camera.CFrame.p
			if not newpos then
				local part, newpos_ = workspace:FindPartOnRayWithWhitelist(
					Ray.new(Camera.CFrame.p, Camera.CFrame.LookVector * 1000),
					client.roundsystem.raycastwhitelist
				)
				newpos = newpos_
			end
			local unit = (newpos - start).Unit
			local dist = (newpos - start).Magnitude
			for i = 1, dist, 2 do
				for j = 1, #rootparts do
					local rootpart = rootparts[j]
					if not rootpart then continue end
					rootpart.Position += unit
				end
				if not menu:GetKey("Misc", "Exploits", "Crimwalk") then
					client.net:send("repupdate", rootpart.Position + Vector3.new(0, client.char.headheight, 0), ragebot.angles)
				end
			end
			
		end
		local setsway = client.cam.setswayspeed
		client.cam.setswayspeed = function(self, v)
			setsway(self, menu:GetVal("Visuals", "Camera Visuals", "No Scope Sway") and 0 or v)
		end

		function misc:GetParts(parts)
			parts["Head"] = parts[1]
			parts["Torso"] = parts[2]
			parts["Right Arm"] = parts[3]
			parts["Left Arm"] = parts[3]
			parts["Right Leg"] = parts[4]
			parts["Left Leg"] = parts[4]
			parts["rleg"] = parts[4]
			parts["lleg"] = parts[4]
			parts["rarm"] = parts[3]
			parts["larm"] = parts[3]
			parts["head"] = parts[1]
			parts["torso"] = parts[2]
			return parts
		end
		local rootpart1
		local humanoid

		function misc:SpotPlayers()
			if not menu:GetVal("Misc", "Extra", "Auto Spot") then
				return
			end
			local players = {}
			for k, player in pairs(game.Players:GetPlayers()) do
				if player == game.Players.LocalPlayer then
					continue
				end
				table.insert(players, player)
			end
			return send("spotplayers", players)
		end

		function misc:ApplyGunMods()
			local mods_enabled = menu:GetVal("Misc", "Weapon Modifications", "Enabled")
			local firerate_scale = menu:GetVal("Misc", "Weapon Modifications", "Fire Rate Scale") / 100
			--local recoil_scale = menu:GetVal("Misc", "Weapon Modifications", "Recoil Scale") / 100
			local empty_animations = menu:GetVal("Misc", "Weapon Modifications", "Remove Animations")
			local instant_equip = menu:GetVal("Misc", "Weapon Modifications", "Instant Equip")
			local fully_auto = menu:GetVal("Misc", "Weapon Modifications", "Fully Automatic")

			for i, gun_module in pairs(CUR_GUNS:GetChildren()) do
				local gun = require(gun_module)
				local old_gun = require(OLD_GUNS[gun_module.Name])
				for k, v in pairs(old_gun) do
					gun[k] = v
				end

				if mods_enabled then
					do --firerate
						if gun.variablefirerate then
							for k, v in pairs(gun.firerate) do
								v *= firerate_scale
							end
						elseif gun.firerate then
							gun.firerate *= firerate_scale
						end
					end
					if fully_auto and gun.firemodes then
						gun.firemodes = { true, 3, 1 }
					end
					--[[if gun.camkickmin then	--recoil fuk dis
						gun.camkickmin *= recoil_scale
						gun.camkickmax *= recoil_scale
						gun.aimcamkickmin *= recoil_scale
						gun.aimcamkickmax *= recoil_scale
						gun.aimtranskickmin *= recoil_scale
						gun.aimtranskickmax *= recoil_scale
						gun.transkickmin *= recoil_scale
						gun.transkickmax *= recoil_scale
						gun.rotkickmin *= recoil_scale
						gun.rotkickmax *= recoil_scale
						gun.aimrotkickmin *= recoil_scale
						gun.aimrotkickmax *= recoil_scale
						gun.hipfirespreadrecover *= recoil_scale
						gun.hipfirespread *= recoil_scale
						gun.hipfirestability *= recoil_scale
					end]]
					if instant_equip then
						gun.equipspeed = 99999
					end
					if empty_animations then
						client.animation.player = animhook
						client.animation.reset = animhook
					else
						client.animation.player = client.animation.oldplayer
						client.animation.reset = client.animation.oldreset
					end
				end
			end
		end
		do
			client.springhooks = {}
			function client:UnhookSprings()
				for i = 1, #client.springhooks do
					local hook = client.springhooks[i]
					setrawmetatable(hook.spring, hook.meta)
				end
				table.clear(client.springhooks)
			end
			function client:HookSpring(spring, newMetatable)
				if #client.springhooks > 0 then
					for i = 1, #client.springhooks do
						local hook = client.springhooks[i]
						if hook.spring == spring then
							--warn("Error, tried to hook spring twice")
							return
						end
					end
				end
				local originalMetatable = getrawmetatable(spring)
				assert(originalMetatable, "Invalid argument given for 'spring'")
				client.springhooks[#client.springhooks + 1] = {
					spring = spring,
					meta = originalMetatable,
				}
				for metafunc, func in next, originalMetatable do
					if not newMetatable[metafunc] then
						newMetatable[metafunc] = originalMetatable[metafunc]
					else
						local userFunc = newMetatable[metafunc]
						newMetatable[metafunc] = function(t, p)
							return userFunc(t, p, originalMetatable)
						end
					end
				end
				setrawmetatable(spring, newMetatable)
			end
			local swingspring = debug.getupvalue(client.char.step, 15)
			local sprintspring = debug.getupvalue(client.char.setsprint, 10)
			local zoommodspring = debug.getupvalue(client.char.step, 1) -- sex.

			client.zoommodspring = zoommodspring -- fuck

			local oldjump = client.char.jump
			function client.char:jump(height)
				height = (menu and menu:GetVal("Misc", "Tweaks", "Jump Power")) and (height * menu:GetVal("Misc", "Tweaks", "Jump Power Percentage") / 100) or height
				return oldjump(self, height)
			end

			client:HookSpring(swingspring, {
				__index = function(t, p, oldSpring)
					if p == "v" and menu:GetVal("Misc", "Weapon Modifications", "Run and Gun") then
						return Vector3.new()
					end
					return oldSpring.__index(t, p)
				end,
			})

			client:HookSpring(sprintspring, {
				__index = function(t, p, oldSpring)
					if p == "p" and menu:GetVal("Misc", "Weapon Modifications", "Run and Gun") then
						return 0
					end
					return oldSpring.__index(t, p)
				end,
			})

			--[[ client.springindex = old_index
			
			spring.__index = newcclosure(function(t, k)
				local result = old_index(t, k)
				if t == swingspring then
					if k == "v" and menu:GetVal("Misc", "Weapon Modifications", "Run and Gun") then
						return Vector3.new()
					end
				end
				if t == sprintspring then
					if k == "p" and menu:GetVal("Misc", "Weapon Modifications", "Run and Gun") then
						return 0
					end
				end
				
				if t == zoommodspring then
					if k == "p" and menu:GetVal("Visuals", "Camera Visuals", "Disable ADS FOV") then 
						return 0
					end
				end
				return result
			end) ]]
		end
		menu.connections.button_pressed_pf = ButtonPressed:connect(function(tab, gb, name)
			

			if name == "Join New Game" then
				TELEPORT_SERVICE:Teleport(game.PlaceId, game.Players.LocalPlayer)
			end

			if name == "Votekick" then
				local rank = client.rankcalculator(client.dirtyplayerdata.stats.experience)
				if not selectedPlayer then
					return
				end

				if rank >= 25 then
					client.net:send("modcmd", string.format("/votekick:%s:cheating", selectedPlayer.Name))
				else
					CreateNotification(string.format("Your account must be rank 25 or above to votekick! (Rank %d)", rank))
				end
			elseif name == "Spectate" then
				if menu.spectating ~= selectedPlayer and client.hud:isplayeralive(selectedPlayer) then
					client.cam:setspectate(selectedPlayer)
					menu.spectating = selectedPlayer
				else
					if client.char.alive then
						client.cam:setfirstpersoncam()
					else
						local lobby = workspace:FindFirstChild("MenuLobby")
						if lobby then
							client.cam:setmenucam(lobby)
						else
							client.menu:loadmenu()
						end
					end
					menu.spectating = false
				end
			end
		end)

		menu.connections.toggle_pressed_pf = TogglePressed:connect(function(tab, name, class)
			if name == "Enabled" and tab == "Weapon Modifications" then
				client.animation.player = (class[1] and menu:GetVal("Misc", "Weapon Modifications", "Remove Animations")) and animhook or client.animation.oldplayer
				client.animation.reset = (class[1] and menu:GetVal("Misc", "Weapon Modifications", "Remove Animations")) and animhook or client.animation.oldreset
			end
			if name == "Remove Animations" then
				client.animation.player = (class[1] and menu:GetVal("Misc", "Weapon Modifications", "Enabled")) and animhook or client.animation.oldplayer
				client.animation.reset = (class[1] and menu:GetVal("Misc", "Weapon Modifications", "Remove Animations")) and animhook or client.animation.oldreset
			end
			if name == "Arm Chams" then -- TODO try to return the arms and weapon back to their original  colors and everything and shit
				if not class[1] then
					local vm = workspace.CurrentCamera:GetChildren()
					for i = 1, #vm do
						local model = vm[i]
						if model.Name:match(".*Arm$") then
							local children = model:GetChildren()
							for j = 1, #children do
								local part = children[j]
								--part.Color = originalArmColor
								if part.Transparency ~= 1 then
									part.Transparency = 0
								end
								--part.Material = mats[armmaterial]
								if part.ClassName == "MeshPart" or part.Name == "Sleeve" then
									--part.Color = menu:GetVal("Visuals", "Local", "Arm Chams", COLOR1, true)
									if part.Transparency ~= 1 then
										part.Transparency = 0
									end
								end
							end
						end
					end
				end
			elseif name == "Weapon Chams" then
				if not class[1] then
					local vm = workspace.CurrentCamera:GetChildren()
					for i = 1, #vm do
						local model = vm[i]
						if not model.Name:match(".*Arm$") and not model.Name:match(".*FRAG$") then
							local children = model:GetChildren()
							for j = 1, #children do
								local part = children[j]
								--part.Color = originalWeaponColor
								if part.Transparency ~= 1 then
									part.Transparency = 0
								end
								--part.Material = mats[Weaponmaterial]
								if part.ClassName == "MeshPart" or part.Name == "Sleeve" then
									--part.Color = menu:GetVal("Visuals", "Local", "Weapon Chams", COLOR1, true)
									if part.Transparency ~= 1 then
										part.Transparency = 0
									end
								end
							end
						end
					end
				end
			end
		end)

		--[[function misc:RoundFreeze()
			if textboxopen then
				client.roundsystem.lock = true
				return
			end
			if menu:GetVal("Misc", "Movement", "Ignore Round Freeze") then
				client.roundsystem.lock = false
			end
		end]]

		function misc:FlyHack()
			if menu:GetVal("Misc", "Movement", "Fly") and menu:GetKey("Misc", "Movement", "Fly") then
				local speed = menu:GetVal("Misc", "Movement", "Fly Speed")

				local travel = CACHED_VEC3
				local looking = Camera.CFrame.lookVector --getting camera looking vector
				local rightVector = Camera.CFrame.RightVector
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.W) then
					travel += looking
				end
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.S) then
					travel -= looking
				end
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.D) then
					travel += rightVector
				end
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.A) then
					travel -= rightVector
				end
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.Space) then
					travel += Vector3.new(0, 1, 0)
				end
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftShift) then
					travel -= Vector3.new(0, 1, 0)
				end
				if travel.Unit.x == travel.Unit.x then
					rootpart.Anchored = false
					rootpart.Velocity = travel.Unit * speed --multiply the unit by the speed to make
				else
					rootpart.Velocity = Vector3.new(0, 0, 0)
					rootpart.Anchored = true
				end
			end
			if not menu:GetKey("Misc", "Movement", "Fly") then
				rootpart.Anchored = false
			end
		end
		misc.speedDirection = Vector3.new(1,0,0)
		function misc:SpeedHack()
			if menu:GetKey("Misc", "Movement", "Fly") then
				return
			end
			local speedtype = menu:GetVal("Misc", "Movement", "Speed Type")
			if menu:GetVal("Misc", "Movement", "Speed") then
				local speed = menu:GetVal("Misc", "Movement", "Speed Factor")

				local travel = CACHED_VEC3
				local looking = Camera.CFrame.LookVector
				local rightVector = Camera.CFrame.RightVector
				local moving = false
				if not menu:GetKey("Misc", "Movement", "Circle Strafe") then
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.W) then
						travel += looking
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.S) then
						travel -= looking
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.D) then
						travel += rightVector
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.A) then
						travel -= rightVector
					end
					misc.speedDirection = Vector3.new(travel.x, 0, travel.z).Unit
					-- if misc.speedDirection.x ~= misc.speedDirection.x then 
					-- 	misc.speedDirection = Vector3.new(looking.x, 0, looking.y)
					-- end
					misc.circleStrafeAngle = -0.1
				else
					if misc.speedDirection.x ~= misc.speedDirection.x then 
						misc.speedDirection = Vector3.new(looking.x, 0, looking.y)
					end
					travel = misc.speedDirection
					misc.circleStrafeAngle = -0.1
					
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.D) then
						misc.circleStrafeAngle = 0.1
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.A) then
						misc.circleStrafeAngle = -0.1
					end
					local cd = Vector2.new(misc.speedDirection.x, misc.speedDirection.z)
					cd = bVector2:getRotate(cd, misc.circleStrafeAngle)
					misc.speedDirection = Vector3.new(cd.x, 0, cd.y)
				end

				travel = misc.speedDirection
				if menu:GetKey("Misc", "Movement", "Avoid Collisions") then
					if menu:GetKey("Misc", "Movement", "Circle Strafe") then
						local scale = menu:GetVal("Misc", "Movement", "Avoid Collisions Scale") / 1000
						local position = client.char.rootpart.CFrame.p
						local part, position, normal = workspace:FindPartOnRayWithWhitelist(
							Ray.new(position, (travel * speed * scale)),
							client.roundsystem.raycastwhitelist
						) 
						if part then
							for i = -10, 10 do
								local cd = Vector2.new(travel.x, travel.z)
								cd = bVector2:getRotate(cd, misc.circleStrafeAngle * i * -1)
								cd = Vector3.new(cd.x, 0, cd.y)
								local part, position, normal = workspace:FindPartOnRayWithWhitelist(
									Ray.new(position, (cd * speed * scale)),
									client.roundsystem.raycastwhitelist
								) 
								misc.normal = normal
								if not part then 
									travel = cd
								end
							end
						end
					else
						local position = client.char.rootpart.CFrame.p
						for i = 1, 10 do
							local part, position, normal = workspace:FindPartOnRayWithWhitelist(
								Ray.new(position, (travel * speed / 10) + Vector3.new(0,rootpart.Velocity.y/10,0)),
								client.roundsystem.raycastwhitelist
							) 
							misc.normal = normal
							if part then 
								local dot = normal.Unit:Dot((client.char.rootpart.CFrame.p - position).Unit)
								misc.normalPositive = dot
								if dot > 0 then
									travel += normal.Unit * dot
									travel = travel.Unit
									if travel.x == travel.x then
										misc.circleStrafeDirection = travel
									end
								end
							end
						end
					end
				end
				if travel.x == travel.x and humanoid:GetState() ~= Enum.HumanoidStateType.Climbing then
					if speedtype == 2 and (humanoid:GetState() ~= Enum.HumanoidStateType.Freefall or not humanoid.Jump)
					then
						return
					elseif speedtype == 3 and not INPUT_SERVICE:IsKeyDown(Enum.KeyCode.Space) then
						return
					end
				
					if menu:GetKey("Misc", "Movement", "Speed", true) then
						rootpart.Velocity = Vector3.new(travel.x * speed, rootpart.Velocity.y, travel.z * speed)
					end
				end
			end
		end

		local autopeekiterator = 5
		function misc:AutoPeek()
			if self.autopeektimeout and self.autopeektimeout > 0 then
				self.autopeektimeout -= 1
				return
			end

			if not client.char.alive then
				return
			end
			if menu:GetKey("Rage", "Extra", "Auto Peek") and menu:GetVal("Rage", "Aimbot", "Enabled") then
				local hitscanpreference = misc:GetParts({ [menu:GetVal("Rage", "Aimbot", "Hitscan Priority")] = true })
				local prioritizedpart = menu:GetVal("Rage", "Aimbot", "Hitscan Priority")

				autopeekiterator += 10
				local dist = (autopeekiterator % 20) + 10
				local origin = client.lastrepupdate + Camera.CFrame.LookVector * dist
				if not self.autopeekposition then
					local targetPart, targetPlayer, fov, firepos, head, newbone, hitbox = ragebot:GetTarget(prioritizedpart, nil, CFrame.new(origin))
					

					self.autopeekposition = firepos
					if self.autopeekposition and workspace:Raycast(
							client.lastrepupdate,
							self.autopeekposition - client.lastrepupdate,
							mapRaycast
						)
					then
						self.autopeekposition = nil
					end
				end
				if self.autopeekposition and not workspace:Raycast(client.lastrepupdate, self.autopeekposition - client.lastrepupdate, mapRaycast)
				then
					misc:Teleport(self.autopeekposition)
					self.autopeekposition = nil
					self.autopeektimeout = 100
				end
			else
				self.autopeekposition = nil
			end
		end

		function misc:AutoJump()
			if menu:GetVal("Misc", "Movement", "Auto Jump") and INPUT_SERVICE:IsKeyDown(Enum.KeyCode.Space) then
				humanoid.Jump = true
			end
		end

		function misc:GravityShift()
			if menu:GetVal("Misc", "Tweaks", "Gravity Shift") then
				local scaling = menu:GetVal("Misc", "Tweaks", "Gravity Shift Percentage")
				local mappedGrav = map(scaling, -100, 100, -196.2, 196.2)
				workspace.Gravity = 196.2 + mappedGrav
			else
				workspace.Gravity = 196.2
			end
		end

		function misc:MainLoop()

			if menu:GetKey("Misc", "Exploits", "Lock Player Positions") then
				NETWORK_SETTINGS.IncomingReplicationLag = 9e9
			else
				NETWORK_SETTINGS.IncomingReplicationLag = 0
			end
			
			
			rootpart = LOCAL_PLAYER.Character and client.char.rootpart
			rootpart = self.invisroot or self.newroot or rootpart
			humanoid = LOCAL_PLAYER.Character and LOCAL_PLAYER.Character:FindFirstChild("Humanoid")
			misc:BypassSpeedCheck(menu:GetVal("Misc", "Exploits", "Bypass Speed Checks") and not tpval and not lastval)
			if rootpart and humanoid then
				if not CHAT_BOX.Active then
					misc:SpeedHack()
					misc:FlyHack()
					misc:AutoJump()
					misc:GravityShift()
					misc:AutoPeek()
					--misc:RoundFreeze()
				elseif menu:GetKey("Misc", "Movement", "Fly") then
					rootpart.Anchored = true
				end
			end
			local newval, lastval = menu:GetVal("Misc", "Extra", "Break Windows")
			if newval ~= lastval and newval then
				CreateThread(function()
					local parts = workspace.Map:GetDescendants() 
					for i = 1, #parts do
						local part = parts[i]
						if part.Name == "Window" then
							client.effects.breakwindow(part, part, nil, true, true, nil, nil, nil)
						end
					end
				end)
			end
		end
		client.stutterFrames = 0

		do --ANCHOR send hook
			client.net.send = function(self, ...)

				local args = { ... }
				-- if menu and menu:GetVal("Misc", "Exploits", "Skin Changer") and args[1] == "changecamo" then
				-- 	local tid = menu:GetVal("Misc", "Exploits", "skinchangerTexture")
				-- 	args[6].TextureProperties.TextureId = tid == "" and nil or tid
				-- 	args[6].TextureProperties.Transparency = 1 - menu:GetVal("Misc", "Exploits", "Skin Changer", COLOR)[4] / 255
				-- 	args[6].TextureProperties.StudsPerTileU = menu:GetVal("Misc", "Exploits", "Scale X") / 100
				-- 	args[6].TextureProperties.StudsPerTileV = menu:GetVal("Misc", "Exploits", "Scale Y") / 100
				-- 	args[6].BrickProperties.BrickColor = menu:GetVal("Misc", "Exploits", "Skin Changer", COLOR, true)
				-- 	args[6].BrickProperties.Material = mats[menu:GetVal("Misc", "Exploits", "Skin Material")]
				-- end
				if args[1] == "spawn" then
					UnpackRelations()
					if menu:GetVal("Misc", "Extra", "Break Windows") then
						CreateThread(function()
							local parts = workspace.Map:GetDescendants() 
							for i = 1, #parts do
								local part = parts[i]
								if part.Name == "Window" then
									client.effects.breakwindow(part, part, nil, true, true, nil, nil, nil)
								end
							end
						end)
					end
					misc.model = nil
					misc:ApplyGunMods()
					misc.autopeektimeout = 100
				end
				if args[1] == "logmessage" or args[1] == "debug" then
					CreateThread(function()
						wait(1)
						menu.debugged = true
					end)
					local message = ""
					for i = 1, #args - 1 do
						message ..= tostring(args[i]) .. ", "
					end
					message ..= tostring(args[#args])
					if message:find("Kick") then
						if menu:GetVal("Misc", "Extra", "Join New Game On Kick") then
							TELEPORT_SERVICE:Teleport(game.PlaceId)
						end
						return
					end
					if not menu.debugged then 
						CreateNotification(message)
					end
					return
				end
				if args[1] == "repupdate" then
					if misc.teleporting then
						return
					elseif args[2] ~= args[2] or args[2].Unit.X ~= args[2].Unit.X then
						return
					end
				end
				if args[1] == "chatted" then
					local message = args[2]
					local commandLocation = #message > 1 and string.find(message, "\\")
					if commandLocation == 1 then
						local i = 1
						local args = {}
						local func
						local name
						for f in message:gmatch("%w+") do
							if i == 1 then
								name = f:lower()
								func = CommandFunctions[f:lower()]
							else
								table.insert(args, f)
							end
							i += 1
						end
						if name == "cmdlist" or name == "help" then
							return CommandFunctions.cmdlist(CommandFunctions, unpack(args))
						end
						if func then
							return func(unpack(args))
						else
							return CreateNotification("Not a command, try \"\\help\" to see available commands.")
						end
					end
				end
				if args[1] == "bullethit" and menu:GetVal("Misc", "Extra", "Suppress Only") then
					return
				end
				if args[1] == "bullethit" or args[1] == "knifehit" then
					if table.find(menu.friends, args[2].Name) and menu:GetVal("Misc", "Extra", "Ignore Friends")
					then
						return
					end
				end
				if args[1] == "stance" and menu:GetVal("Rage", "Anti Aim", "Enabled") and menu:GetVal("Rage", "Anti Aim", "Force Stance") ~= 1
				then
					return
				end
				if args[1] == "sprint" and menu:GetVal("Rage", "Anti Aim", "Enabled") and menu:GetVal("Rage", "Anti Aim", "Lower Arms")
				then
					return
				end
				if args[1] == "falldamage" then
					if menu:GetVal("Misc", "Tweaks", "Prevent Fall Damage") or misc.teleporting then
						return
					end
				end
				if args[1] == "newgrenade" and menu:GetVal("Misc", "Exploits", "Grenade Teleport") then
					local closest = math.huge
					local part
					for i, player in pairs(Players:GetPlayers()) do
						if table.find(menu.friends, player.Name) and menu:GetVal("Misc", "Extra", "Ignore Friends")
						then
							continue
						end
						if not table.find(menu.priority, player.Name) and menu:GetVal("Misc", "Extra", "Target Only Priority Players")
						then
							continue
						end
						if player.Team ~= LOCAL_PLAYER.Team and player ~= LOCAL_PLAYER then
							local bodyparts = client.replication.getbodyparts(player)
							if bodyparts then
								local fovToBone = camera:GetFOV(bodyparts.head)
								if fovToBone < closest then
									closest = fovToBone
									part = bodyparts.head
								end
							end
						end
					end

					if (closest and part) then
						local args = {
							"FRAG",
							{
								frames = {
									{
										v0 = Vector3.new(),
										glassbreaks = {},
										t0 = 0,
										offset = Vector3.new(),
										rot0 = CFrame.new(),
										a = Vector3.new(0 / 0),
										p0 = client.lastrepupdate or client.char.head.Position,
										rotv = Vector3.new(),
									},
									{
										v0 = Vector3.new(),
										glassbreaks = {},
										t0 = 0.002,
										offset = Vector3.new(),
										rot0 = CFrame.new(),
										a = Vector3.new(0 / 0),
										p0 = Vector3.new(0 / 0),
										rotv = Vector3.new(),
									},
									{
										v0 = Vector3.new(),
										glassbreaks = {},
										t0 = 0.003,
										offset = Vector3.new(),
										rot0 = CFrame.new(),
										a = Vector3.new(),
										p0 = part.Position + Vector3.new(0, 3, 0),
										rotv = Vector3.new(),
									},
								},
								time = tick(),
								blowuptime = 0.003,
							},
						}

						send(client.net, "newgrenade", unpack(args))
						client.hud:updateammo("GRENADE")
						return
					end
				elseif args[1] == "newbullets" then
					if menu:GetVal("Misc", "Exploits", "Fake Equip") then
						send(self, "equip", client.logic.currentgun.id)
					end

					if legitbot.silentVector then
						for k = 1, #args[2].bullets do
							local bullet = args[2].bullets[k]
							bullet[1] = legitbot.silentVector
						end
					end

					if ragebot.silentVector then
						-- duct tape fix or whatever the fuck its called for this its stupid
						args[2].camerapos = client.lastrepupdate -- attempt to make dumping happen less
						args[2].firepos = ragebot.firepos
						-- if shitting_my_pants == false and menu:GetVal("Misc", "Exploits", "Noclip") and keybindtoggles.fakebody then
						-- 	args[2].camerapos = client.cam.cframe.p - Vector3.new(0, client.fakeoffset, 0)
						-- end
						local cachedtimedata = {}
						
						local hitpoint = ragebot.intersection or ragebot.targetpart.Position
						-- i need to improve this intersection system a lot, because this can cause problems and nil out and not register the hit
						-- properly when you're using Aimbot Performance Mode... fuggjegrnjeiar ngreoi greion agreino agrenoigenroino

						local angle, bullettime = client.trajectory(
								ragebot.firepos,
								GRAVITY,
								hitpoint,
								client.logic.currentgun.data.bulletspeed
							)
						if not angle or not bullettime then
							return
						end
						for k = 1, #args[2].bullets do
							local bullet = args[2].bullets[k]
							bullet[1] = angle
						end

						if menu:GetVal("Rage", "Fake Lag", "Release Packets on Shoot") then
							menu:SetKey("Rage", "Fake Lag", "Manual Choke")
							ragebot.choking = false
							client.fakelagpos = nil
							syn.set_thread_identity(1) -- might lag...... idk probably not
							NETWORK:SetOutgoingKBPSLimit(0)
						end
						ragebot.lasthittime = ragebot.time
						ragebot.lasthittick = tick()
						args[3] = ragebot.time - bullettime
						send(self, unpack(args))

						for k = 1, #args[2].bullets do
							local bullet = args[2].bullets[k]
							if menu:GetVal("Visuals", "Misc", "Bullet Tracers") then
								local origin = args[2].firepos
								local attach_origin = Instance.new("Attachment", workspace.Terrain)
								attach_origin.Position = origin
								local ending = origin + bullet[1].unit.Unit * 300
								local attach_ending = Instance.new("Attachment", workspace.Terrain)
								attach_ending.Position = ending
								local beam = misc:CreateBeam(attach_origin, attach_ending)
								beam.Parent = workspace
							end
							local hitinfo = {
								ragebot.target,
								hitpoint,
								ragebot.targetpart,
								bullet[2],
							}
							client.hud:firehitmarker(ragebot.targetpart.Name == "Head")
							client.sound.PlaySound("hitmarker", nil, 1, 1.5)
							send(self, "bullethit", unpack(hitinfo))
						end
						if menu:GetVal("Misc", "Exploits", "Fake Equip") then
							local slot = menu:GetVal("Misc", "Exploits", "Fake Slot")
							send(self, "equip", slot)
						end
						return
					else
						if menu:GetVal("Visuals", "Misc", "Bullet Tracers") then
							for k = 1, #args[2].bullets do
								local bullet = args[2].bullets[k]
								local origin = args[2].firepos
								local attach_origin = Instance.new("Attachment", workspace.Terrain)
								attach_origin.Position = origin
								local ending = origin + (type(bullet[1]) == "table" and bullet[1].unit.Unit or bullet[1].Unit) * 300
								local attach_ending = Instance.new("Attachment", workspace.Terrain)
								attach_ending.Position = ending
								local beam = misc:CreateBeam(attach_origin, attach_ending)
								beam.Parent = workspace
							end
						end
					end

					if menu:GetVal("Misc", "Exploits", "Fake Equip") then
						local slot = menu:GetVal("Misc", "Exploits", "Fake Slot")
						send(self, "equip", slot)
					end
				elseif args[1] == "stab" then
					syn.set_thread_identity(1)
					NETWORK:SetOutgoingKBPSLimit(0)
					client.fakelagpos = nil
					ragebot.choking = false
					menu:SetKey("Rage", "Fake Lag", "Manual Choke")
					if menu:GetVal("Rage", "Extra", "Knife Bot") and menu:GetKey("Rage", "Extra", "Knife Bot", true)
					then
						if menu:GetVal("Rage", "Extra", "Knife Bot Type") == 1 then
							ragebot:KnifeTarget(ragebot:GetKnifeTargets()[1])
						end
					end
				elseif args[1] == "equip" then
					if client.fakecharacter then -- finally added knife showing on 3p shit after like month
						if args[2] ~= 3 then
							local gun = client.loadedguns[args[2]].name
							client.fakeupdater.equip(
								require(game:service("ReplicatedStorage").GunModules[gun]),
								game:service("ReplicatedStorage").ExternalModels[gun]:Clone()
							)
						else
							local gun = client.logic.currentgun.name
							client.fakeupdater.equipknife(
								require(game:service("ReplicatedStorage").GunModules[gun]),
								game:service("ReplicatedStorage").ExternalModels[gun]:Clone()
							)
						end
					end

					if menu:GetVal("Misc", "Exploits", "Fake Equip") then
						local slot = menu:GetVal("Misc", "Exploits", "Fake Slot")
						args[2] = slot
					end
				elseif args[1] == "repupdate" then
					local crimwalk, lastcrimwalk = menu:GetKey("Misc", "Exploits", "Crimwalk")
					if crimwalk and client.lastrepupdate then
						if menu:GetVal("Misc", "Exploits", "Disable Crimwalk on Shot") and ragebot.target then
							client.lastcrimwalkpos = args[2]
							args[2] = client.lastrepupdate
							LOCAL_PLAYER.Character.HumanoidRootPart.Position = client.lastrepupdate
						else
							return
						end
					end
					if lastcrimwalk and not crimwalk then
						LOCAL_PLAYER.Character.HumanoidRootPart.Position = client.lastrepupdate
						args[2] = client.lastrepupdate
					end
					uberpart.Transparency = menu:GetKey("Rage", "Hack vs. Hack", "Freestanding") and 0 or 1
					if menu:GetKey("Rage", "Hack vs. Hack", "Freestanding") then
						for i = 1, #directiontable do
							--local direction = directiontable[i].Unit * 19
							local cf = client.cam.basecframe
							cf -= cf.UpVector
							local translated = vtos(cf, directiontable[i])
							local direction = translated.Unit * 19
							--local direction = directiontable[i].Unit *

							local raycastResult = workspace:Raycast(args[2], direction, mapRaycast)

							if raycastResult then
								--args[1] = raycastResult.Position
								local normal = raycastResult.Normal
								local hitpos = raycastResult.Position
								local newpos = hitpos + normal
								--local newpos = ptos(raycast)
								uberpart.Position = newpos
								args[2] = newpos
								break
							end
						end
					end
					client.lastrepupdate = args[2]
					-- if shitting_my_pants == false and menu:GetVal("Misc", "Exploits", "Noclip") and keybindtoggles.fakebody then
					-- 	if not client.fakeoffset then client.fakeoffset = 18 end

					-- 	local nextinc = client.fakeoffset + 9
					-- 	client.fakeoffset = nextinc <= 48 and nextinc or client.fakeoffset
					-- end
					if menu:GetVal("Rage", "Anti Aim", "Enabled") then
						--args[2] = ragebot:AntiNade(args[2])
						client.stutterFrames += 1
						local pitch = args[3].x
						local yaw = args[3].y
						local pitchChoice = menu:GetVal("Rage", "Anti Aim", "Pitch")
						local yawChoice = menu:GetVal("Rage", "Anti Aim", "Yaw")
						local spinRate = menu:GetVal("Rage", "Anti Aim", "Spin Rate")
						---"off,down,up,roll,upside down,random"
						--{"Off", "Up", "Zero", "Down", "Upside Down", "Roll Forward", "Roll Backward", "Random"} pitch
						local new_angles
						if pitchChoice == 2 then
							pitch = -4
						elseif pitchChoice == 3 then
							pitch = 0
						elseif pitchChoice == 4 then
							pitch = 4.7
						elseif pitchChoice == 5 then
							pitch = -math.pi
						elseif pitchChoice == 6 then
							pitch = (tick() * spinRate) % 6.28
						elseif pitchChoice == 7 then
							pitch = (-tick() * spinRate) % 6.28
						elseif pitchChoice == 8 then
							pitch = math.random(99999)
						elseif pitchChoice == 9 then
							pitch = math.sin((tick() % 6.28) * spinRate)
						elseif pitchChoice == 10 then
							pitch = 2 ^ 127 + 1
						end

						--{"Off", "Backward", "Spin", "Random"} yaw
						if yawChoice == 2 then
							yaw += math.pi
						elseif yawChoice == 3 then
							yaw = (tick() * spinRate) % 12
						elseif yawChoice == 4 then
							yaw = math.random(99999)
						elseif yawChoice == 5 then
							yaw = 16478887
						elseif yawChoice == 6 then
							yaw = client.stutterFrames % (6 * (spinRate / 4)) >= ((6 * (spinRate / 4)) / 2) and 2 or -2
						elseif yawChoice == 7 then
							new_angles = Vector2.new()
						end

						-- yaw += jitter

						new_angles = new_angles or Vector2.new(clamp(pitch, 1.47262156, -1.47262156), yaw)
						-- args[3] = new_angles
						ragebot.angles = new_angles
					else
						ragebot.angles = args[3]
					end
				end
				return send(self, unpack(args))
			end
			-- Legitbot definition defines legit functions
			-- Legitbot definition defines legit functions
			-- Legitbot definition defines legit functions
			-- Legitbot definition defines legit functions
			-- Legitbot definition defines legit functions
			-- Legitbot definition defines legit functions
			-- Not Rage Functons Dumbass

			do -- ANCHOR Legitbot definition defines legit functions
				legitbot.triggerbotShooting = false
				legitbot.silentAiming = false
				legitbot.silentVector = nil

				local function Move_Mouse(delta)
					local coef = client.cam.sensitivitymult * math.atan(
						math.tan(client.cam.basefov * (math.pi / 180) / 2) / 2.72 ^ client.cam.magspring.p
					) / (32 * math.pi)
					local x = client.cam.angles.x - coef * delta.y
					x = x > client.cam.maxangle and client.cam.maxangle or x < client.cam.minangle and client.cam.minangle or x
					local y = client.cam.angles.y - coef * delta.x
					local newangles = Vector3.new(x, y, 0)
					client.cam.delta = (newangles - client.cam.angles) / 0.016666666666666666
					client.cam.angles = newangles
				end

				function legitbot:MainLoop()
					legitbot.target = nil

					if not menu.open and INPUT_SERVICE.MouseBehavior ~= Enum.MouseBehavior.Default and client.logic.currentgun
					then
						--debug.profilebegin("Legitbot Main")
						if menu:GetVal("Legit", "Aim Assist", "Enabled") then
							local keybind = menu:GetVal("Legit", "Aim Assist", "Aimbot Key") - 1
							local fov = menu:GetVal("Legit", "Aim Assist", "Aimbot FOV")
							local sFov = menu:GetVal("Legit", "Bullet Redirection", "Silent Aim FOV")
							local dzFov = menu:GetVal("Legit", "Aim Assist", "Deadzone FOV")

							local hitboxPriority = menu:GetVal("Legit", "Aim Assist", "Hitscan Priority") == 1 and "head" or menu:GetVal("Legit", "Aim Assist", "Hitscan Priority") == 2 and "torso" or "closey :)"
							local hitscan = misc:GetParts(menu:GetVal("Legit", "Aim Assist", "Hitscan Points"))

							if client.logic.currentgun.type ~= "KNIFE" and keybind >= 2 or INPUT_SERVICE:IsMouseButtonPressed(keybind) 
							then
								local speed = 1
								if keybind == 3 then
									speed = 0.2
									for i = 0, 1 do
										if INPUT_SERVICE:IsMouseButtonPressed(i) then
											speed += 0.4
										end
									end
								end
								legitbot.smart = speed
								local priority_list = {}
								for k, PlayerName in pairs(menu.priority) do
									if Players:FindFirstChild(PlayerName) then
										table.insert(priority_list, game.Players[PlayerName])
									end
								end
								local targetPart, closest, player = legitbot:GetTargetLegit(hitboxPriority, hitscan, priority_list, fov, dzFov)
								if not targetPart then
									targetPart, closest, player = legitbot:GetTargetLegit(hitboxPriority, hitscan, nil, fov, dzFov)
								end
								legitbot.target = player
								local smoothing = menu:GetVal("Legit", "Aim Assist", "Smoothing") * 5 + 10
								if targetPart then
									legitbot:AimAtTarget(
										targetPart,
										smoothing,
										menu:GetVal("Legit", "Aim Assist", "Smoothing Type"),
										speed
									)
								end
							end
						end
						if menu:GetVal("Legit", "Bullet Redirection", "Silent Aim") then
							local fov = menu:GetVal("Legit", "Bullet Redirection", "Silent Aim FOV")
							local hnum = menu:GetVal("Legit", "Bullet Redirection", "Hitscan Priority")
							local hitboxPriority = hnum == 1 and "head" or hnum == 2 and "torso" or hnum == 3 and false
							local hitscan = misc:GetParts(menu:GetVal("Legit", "Bullet Redirection", "Hitscan Points"))
							local priority_list = {}
							for k, PlayerName in pairs(menu.priority) do
								if Players:FindFirstChild(PlayerName) then
									table.insert(priority_list, game.Players[PlayerName])
								end
							end
							local targetPart, closest, player = legitbot:GetTargetLegit(hitboxPriority, hitscan, priority_list, fov)
							if not targetPart then
								targetPart, closest, player = legitbot:GetTargetLegit(hitboxPriority, hitscan, nil, fov)
							end
							if targetPart then
								legitbot.silentVector = legitbot:SilentAimAtTarget(targetPart)
							elseif client.logic.currentgun and client.logic.currentgun.barrel then
								legitbot.silentVector = nil
								local barrel = client.logic.currentgun.barrel
								if client.logic.currentgun.type == "SHOTGUN" and barrel and barrel.Parent then
									local trigger = barrel.Parent.Trigger
									if trigger then
										barrel.Orientation = trigger.Orientation
										client:GetToggledSight(client.logic.currentgun).sightpart.Orientation = trigger.Orientation
									end
								end
							end
						end
						--debug.profileend("Legitbot Main")
					end
				end

				function legitbot:AimAtTarget(targetPart, smoothing, smoothtype, speed)
					--debug.profilebegin("Legitbot AimAtTarget")
					if not targetPart then
						return
					end

					local Pos, visCheck

					if menu:GetVal("Legit", "Aim Assist", "Adjust for Bullet Drop") then
						if not client.logic.currentgun or not client.logic.currentgun.data or not client.logic.currentgun.data.bulletspeed
						then
							return
						end
						local bulletVelocity, bulletTravelTime = client.trajectory(
							client.cam.cframe.p,
							GRAVITY,
							targetPart.Position,
							client.logic.currentgun.data.bulletspeed
						)
						local finalPosition
						if menu:GetVal("Legit", "Aim Assist", "Target Prediction") then
							local playerHit = client.replication.getplayerhit(targetPart)
							local rootpart = client.replication.getbodyparts(playerHit).rootpart
							local velocity = rootpart.Velocity
							local finalVelocity = velocity * bulletTravelTime
							finalPosition = targetPart.Position + finalVelocity
							bulletVelocity, bulletTravelTime = client.trajectory(
								client.cam.cframe.p,
								GRAVITY,
								finalPosition,
								client.logic.currentgun.data.bulletspeed
							)
						else
							finalPosition = targetPart.Position
						end
						Pos, visCheck = Camera:WorldToScreenPoint(targetPart.Position + bulletVelocity)
						--Pos, visCheck = Camera:WorldToScreenPoint(camera:GetTrajectory(targetPart.Position, Camera.CFrame.Position))
					else
						Pos, visCheck = Camera:WorldToScreenPoint(targetPart.Position)
					end
					local randMag = menu:GetVal("Legit", "Aim Assist", "Randomization") * 5
					Pos += Vector3.new(
						math.noise(time() * 0.1, 0.1) * randMag,
						math.noise(time() * 0.1, 200) * randMag,
						0
					)

					
					if client.logic.currentgun and client.logic.currentgun.type ~= "KNIFE" and client.logic.currentgun:isaiming() and menu:GetVal("Legit", "Recoil Control", "Weapon RCS")
					then
						local sight = client:GetToggledSight(client.logic.currentgun).sightpart
						local gunpos2d = Camera:WorldToScreenPoint(sight.Position)

						local rcs = Vector2.new(LOCAL_MOUSE.x - gunpos2d.x, LOCAL_MOUSE.y - gunpos2d.y)
						if client.logic.currentgun.data.blackscope and isPlayerScoped or client.logic.currentgun.data.blackscope
						then
							local xo = menu:GetVal("Legit", "Recoil Control", "Recoil Control X")
							local yo = menu:GetVal("Legit", "Recoil Control", "Recoil Control Y")
							local rcsdelta = Vector3.new(rcs.x * xo / 100, rcs.y * yo / 100, 0)  --* client:GetToggledSight(client.logic.currentgun).sightspring.p
							Pos += rcsdelta
						end
					end
					local aimbotMovement = Vector2.new(Pos.x - LOCAL_MOUSE.x, Pos.y - LOCAL_MOUSE.y)
					if smoothtype == 1 then
						Move_Mouse(aimbotMovement * speed / smoothing)
					else
						local unitMovement = aimbotMovement.Unit
						local newMovement = aimbotMovement.Magnitude > unitMovement.Magnitude and unitMovement or aimbotMovement / 50

						Move_Mouse(newMovement * speed / smoothing * 100)
					end
					--debug.profileend("Legitbot AimAtTarget")
				end

				function legitbot:SilentAimAtTarget(targetPart)
					--debug.profilebegin("Legitbot SilentAimAtTarget")

					if not targetPart or not targetPart.Position or not client.logic.currentgun then
						return
					end
					if not client.logic.currentgun or not client.logic.currentgun.barrel then
						return
					end

					if client.logic.currentgun.type == "KNIFE" then
						return
					end

					if math.random(0, 100) > menu:GetVal("Legit", "Bullet Redirection", "Hit Chance") then
						return
					end

					if not client.logic.currentgun.barrel then
						return
					end
					local origin = client.logic.currentgun.isaiming() and client:GetToggledSight(client.logic.currentgun) or client.logic.currentgun.barrel.Position

					local target = targetPart.Position
					local dir, bulletTravelTime = client.trajectory(
							client.cam.cframe.p,
							GRAVITY,
							target,
							client.logic.currentgun.data.bulletspeed
						)
					if menu:GetVal("Legit", "Aim Assist", "Target Prediction") then
						local playerHit = client.replication.getplayerhit(targetPart)
						local rootpart = client.replication.getbodyparts(playerHit).rootpart
						local velocity = rootpart.Velocity
						local finalVelocity = velocity * bulletTravelTime
						target += finalVelocity
						dir = client.trajectory(
							client.cam.cframe.p,
							GRAVITY,
							target,
							client.logic.currentgun.data.bulletspeed
						)
					end
					dir = dir.Unit

					local offsetMult = map(
						(menu:GetVal("Legit", "Bullet Redirection", "Accuracy") / 100 * -1 + 1),
						0,
						1,
						0,
						0.3
					)
					local offset = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5)
					dir += offset * offsetMult

					--debug.profileend("Legitbot SilentAimAtTarget")
					if client.logic.currentgun.type == "SHOTGUN" then
						local x, y, z = CFrame.lookAt(Vector3.new(), dir.Unit):ToOrientation()
						client.logic.currentgun.barrel.Orientation = Vector3.new(math.deg(x), math.deg(y), math.deg(z))
						client:GetToggledSight(client.logic.currentgun).sightpart.Orientation = Vector3.new(math.deg(x), math.deg(y), math.deg(z))
						return
					end
					return dir.Unit
				end

				local function isValidTarget(Bone, Player)
					if camera:IsVisible(Bone) then
						return Bone
					end
				end
				--[[
				if menu:GetVal("Legit", "Aim Assist", "Auto Wallbang") then
					local dir = camera:GetTrajectory(Bone.Position, client.cam.cframe.p) - client.cam.cframe.p
					if ragebot:CanPenetrate(LOCAL_PLAYER, Player, dir, Bone.Position)  then
						closest
					end
				elseif camera:IsVisible(Bone) then
					closest = camera:GetFOV(Bone)
					closestPart = Bone
					player = Player
				end
				]]
				function legitbot:GetTargetLegit(partPreference, hitscan, players, maxfov, minfov)
					minfov = minfov or 0
					--debug.profilebegin("Legitbot GetTargetLegit")
					local closest, closestPart, player = math.huge
					partPreference = partPreference or "what"
					hitscan = hitscan or {}
					players = players or game.Players:GetPlayers()

					if legitbot.target then
						local Parts = client.replication.getbodyparts(legitbot.target)
						if Parts then
							new_closest = closest
							for k, Bone in pairs(Parts) do
								if Bone.ClassName == "Part" and hitscan[k] then
									local fovToBone = camera:GetFOV(Bone)
									if fovToBone > minfov and fovToBone < maxfov and fovToBone < closest then
										local validPart = isValidTarget(Bone, Player)
										if validPart then
											closest = fovToBone
											closestPart = Bone
											player = legitbot.target
											return closestPart, closest, player
										end
									end
								end
							end
						end
					end

					for i, Player in pairs(players) do
						if table.find(menu.friends, Player.Name) and menu:GetVal("Misc", "Extra", "Ignore Friends")
						then
							continue
						end

						if Player.Team ~= LOCAL_PLAYER.Team and Player ~= LOCAL_PLAYER then
							local Parts = client.replication.getbodyparts(Player)
							if Parts then
								new_closest = closest
								for k, Bone in pairs(Parts) do
									if Bone.ClassName == "Part" and hitscan[k] then
										local fovToBone = camera:GetFOV(Bone)
										if fovToBone > minfov and fovToBone < maxfov and fovToBone < closest then
											local validPart = isValidTarget(Bone, Player)
											if validPart then
												closest = fovToBone
												closestPart = Bone
												player = Player
											end
										end
									end
								end
							end
						end
					end

					if player and closestPart then
						local Parts = client.replication.getbodyparts(player)
						if partPreference then
							local PriorityBone = Parts[partPreference]
							if PriorityBone then
								local fov_to_bone = camera:GetFOV(PriorityBone)
								if fov_to_bone and fov_to_bone < closest and camera:IsVisible(PriorityBone) then
									closest = camera:GetFOV(PriorityBone)
									closestPart = PriorityBone
								end
							end
						end
					end
					--debug.profileend("Legitbot GetTargetLegit")
					return closestPart, closest, player
				end

				function legitbot:TriggerBot()
					-- i swear to god the capital GetVal makes me do Menu:GetVal
					if menu:GetVal("Legit", "Trigger Bot", "Enabled") and menu:GetKey("Legit", "Trigger Bot", "Enabled", true)
					then
						local parts = misc:GetParts(menu:GetVal("Legit", "Trigger Bot", "Trigger Bot Hitboxes"))

						local gun = client.logic.currentgun
						if not gun then
							return
						end
						local dsrgposrdjiogjaiogjaoeihjoaiest = "data" -- it loves it

						local thebarrel = gun.barrel
						--debug.profilebegin("Legitbot Triggerbot")
						local bulletspeed = gun.data.bulletspeed
						local isaiming = gun:isaiming()
						local zoomval = menu:GetVal("Legit", "Trigger Bot", "Aim Percentage") / 100
						--local shootallowed = menu:GetVal("Legit", "Trigger Bot", "Trigger When Aiming") and (isaiming and (client.zoommodspring.p > zoomval) or false) or true -- isaiming and (zoommodspring.p > zoomval) or false is somewhat redundant but oh well lmao
						local shootallowed

						if menu:GetVal("Legit", "Trigger Bot", "Trigger When Aiming") then
							shootallowed = isaiming and (client.zoommodspring.p >= zoomval) or false
						else
							shootallowed = true
						end

						if shootallowed then
							for player, bodyparts in next, getupvalue(client.replication.getallparts, 1) do
								if player.Team ~= LOCAL_PLAYER.Team then
									for bpartname, bodypart in next, bodyparts do
										if bodypart:IsA("Part") and bodypart.Transparency == 0 and parts[bpartname]
										then
											if camera:IsVisible(bodypart) then
												local barrel = isaiming and gun.aimsightdata[1].sightpart or thebarrel
												local delta = (bodypart.Position - barrel.Position)
												local direction = client.trajectory(
													barrel.Position,
													GRAVITY,
													bodypart.Position,
													bulletspeed
												).Unit
												local barrelLV = barrel.CFrame.LookVector
												local normalized = barrelLV.unit

												local dot = normalized:Dot(direction)

												if delta.magnitude > 2050 then
													if barrelLV.Y >= direction.Y then
														local dist = delta.magnitude ^ -2.3

														local dotthreshold = 1 - dist

														if dot >= dotthreshold then
															gun:shoot(true)
															legitbot.triggerbotShooting = true
															return
														end
													end
												else
													local whitelist = { bodypart }

													if gun.type == "SHOTGUN" or gun.data.pelletcount then
														table.insert(whitelist, menu.parts.sphereHitbox)
														menu.parts.sphereHitbox.Position = bodypart.Position
													end

													local hit, hitpos = workspace:FindPartOnRayWithWhitelist(
														Ray.new(barrel.Position, normalized * 4000),
														whitelist
													)
													if hit and hit:IsDescendantOf(bodypart.Parent.Parent) or hit == menu.parts.sphereHitbox
													then
														local hitdir = (hitpos - barrel.Position).unit
														if hitdir:Dot(direction) > 0.9993 then
															gun:shoot(true)
															legitbot.triggerbotShooting = true
															return
														end
													end
												end
											end
										elseif legitbot.triggerbotShooting then
											gun:shoot(false)
											legitbot.triggerbotShooting = false
										end
									end
								end
							end
						end
						--[[local hit = workspace:FindPartOnRayWithIgnoreList(Ray.new(barrel.CFrame.Position, barrel.CFrame.LookVector*5000), {Camera, workspace.Players[LOCAL_PLAYER.Team.Name], workspace.Ignore})
						
						if hit and parts[hit.Name] then
							if not camera:IsVisible(hit) then return end
							client.logic.currentgun:shoot(true)
							legitbot.triggerbotShooting = true
						elseif legitbot.triggerbotShooting then
							client.logic.currentgun:shoot(false)
							legitbot.triggerbotShooting = false
						end]]
						--debug.profileend("Legitbot Triggerbot")
					end
				end
			end

			local newpart = client.particle.new
			client.particle.new = function(P)
				local new_speed
				-- if menu:GetVal("Misc", "Weapon Modifications", "Edit Bullet Speed") then
				-- 	new_speed = menu:GetVal("Misc", "Weapon Modifications", "Bullet Speed")
				-- end

				local mag = new_speed or P.velocity.Magnitude

				if not P.thirdperson then
					if menu:GetVal("Legit", "Bullet Redirection", "Silent Aim") and legitbot.silentVector then
						P.velocity = legitbot.silentVector.Unit * mag
					elseif menu:GetVal("Rage", "Aimbot", "Enabled") and menu:GetKey("Rage", "Aimbot", "Enabled", true) and ragebot.silentVector
					then
						local oldpos = P.position
						P.position = ragebot.firepos
						P.velocity = ragebot.silentVector.Unit * mag
						P.visualorigin = ragebot.firepos
						P.ontouch = nil -- paster gave me this idea it will probably help the ragebot not be detected and other shit
					else
						if new_speed then
							P.velocity = P.velocity.Unit * new_speed
						end
					end
				end

				return newpart(P)
			end

			--ADS Fov hook
			local crosshairColors
			local function renderVisuals(dt)
				local _new, _last = menu:GetVal("Misc", "Extra", "Disable 3D Rendering")
				if _new ~= _last then
					game:GetService("RunService"):Set3dRenderingEnabled(not _new)
				end
				misc:UpdateBeams()
				client.char.unaimedfov = menu.options["Visuals"]["Camera Visuals"]["Camera FOV"][1]
				if menu.open then
					--debug.profilebegin("renderVisuals Char")
					local crosshud = PLAYER_GUI.MainGui.GameGui.CrossHud:GetChildren()
					for i = 1, #crosshud do
						local frame = crosshud[i]
						if not crosshairColors then
							crosshairColors = {
								inline = frame.BackgroundColor3,
								outline = frame.BorderColor3,
							}
						end -- MEOW -core 2021
						local inline = menu:GetVal("Visuals", "Misc", "Crosshair Color", COLOR1, true)
						local outline = menu:GetVal("Visuals", "Misc", "Crosshair Color", COLOR2, true)
						local enabled = menu:GetVal("Visuals", "Misc", "Crosshair Color")
						frame.BackgroundColor3 = enabled and inline or crosshairColors.inline
						frame.BorderColor3 = enabled and outline or crosshairColors.outline
					end
					--debug.profileend("renderVisuals Char")
				end -- fun end!
				--------------------------------------world funnies
				--debug.profilebegin("renderVisuals World")
				if menu.options["Visuals"]["World"]["Force Time"][1] then
					game.Lighting.ClockTime = menu.options["Visuals"]["World"]["Custom Time"][1]
				end
				if menu.options["Visuals"]["World"]["Ambience"][1] then
					game.Lighting.Ambient = RGB(
						menu.options["Visuals"]["World"]["Ambience"][5][1][1][1][1],
						menu.options["Visuals"]["World"]["Ambience"][5][1][1][1][2],
						menu.options["Visuals"]["World"]["Ambience"][5][1][1][1][3]
					)
					game.Lighting.OutdoorAmbient = RGB(
						menu.options["Visuals"]["World"]["Ambience"][5][1][2][1][1],
						menu.options["Visuals"]["World"]["Ambience"][5][1][2][1][2],
						menu.options["Visuals"]["World"]["Ambience"][5][1][2][1][3]
					)
				else
					game.Lighting.Ambient = game.Lighting.MapLighting.Ambient.Value
					game.Lighting.OutdoorAmbient = game.Lighting.MapLighting.OutdoorAmbient.Value
				end
				if menu.options["Visuals"]["World"]["Custom Saturation"][1] then
					game.Lighting.MapSaturation.TintColor = RGB(
						menu.options["Visuals"]["World"]["Custom Saturation"][5][1][1],
						menu.options["Visuals"]["World"]["Custom Saturation"][5][1][2],
						menu.options["Visuals"]["World"]["Custom Saturation"][5][1][3]
					)
					game.Lighting.MapSaturation.Saturation = menu.options["Visuals"]["World"]["Saturation Density"][1] / 50
				else
					game.Lighting.MapSaturation.TintColor = RGB(170, 170, 170)
					game.Lighting.MapSaturation.Saturation = -0.25
				end
				--debug.profileend("renderVisuals World")

				--debug.profilebegin("renderVisuals Player ESP Reset")
				-- TODO this reset may need to be improved to a large extent, it's taking up some time but idk if the frame times are becoming worse because of this
				for i = 1, #allesp do
					local drawclass = allesp[i]
					for j = 1, #drawclass do
						local drawdata = drawclass[j]
						for k = 1, #drawdata do
							drawdata[k].Visible = false
						end
					end
				end

				--debug.profileend("renderVisuals Player ESP Reset")

				----------
				--debug.profilebegin("renderVisuals Main")
				if client.logic.currentgun and client.logic.currentgun.barrel and client.char.alive and menu:GetVal("Visuals", "Misc", "Laser Pointer")
				then
					menu.crosshair.outline[1].Visible = true
					menu.crosshair.outline[2].Visible = true
					menu.crosshair.inner[1].Visible = true
					menu.crosshair.inner[2].Visible = true
					local ignore = { workspace.Ignore, Camera }
					local barrel = client.logic.currentgun:isaiming() and client:GetToggledSight(client.logic.currentgun).sightpart or client.logic.currentgun.barrel
					if barrel.Parent then
						local trigger = barrel.Parent.Trigger
						local hit, hitpos = workspace:FindPartOnRayWithIgnoreList(Ray.new(barrel.Position, trigger.CFrame.LookVector * 100), ignore)
						local size = 6
						local color = menu:GetVal("Visuals", "Misc", "Laser Pointer", COLOR, true)
						menu.crosshair.inner[1].Size = Vector2.new(size * 2 + 1, 1)
						menu.crosshair.inner[2].Size = Vector2.new(1, size * 2 + 1)

						menu.crosshair.inner[1].Color = color
						menu.crosshair.inner[2].Color = color

						menu.crosshair.outline[1].Size = Vector2.new(size * 2 + 3, 3)
						menu.crosshair.outline[2].Size = Vector2.new(3, size * 2 + 3)
						local hit2d = Camera:WorldToViewportPoint(hitpos)

						menu.crosshair.inner[1].Position = Vector2.new(hit2d.x - size, hit2d.y)
						menu.crosshair.inner[2].Position = Vector2.new(hit2d.x, hit2d.y - size)
						menu.crosshair.outline[1].Position = Vector2.new(hit2d.x - size - 1, hit2d.y - 1)
						menu.crosshair.outline[2].Position = Vector2.new(hit2d.x - 1, hit2d.y - 1 - size)
					end
				else
					menu.crosshair.outline[1].Visible = false
					menu.crosshair.outline[2].Visible = false
					menu.crosshair.inner[1].Visible = false
					menu.crosshair.inner[2].Visible = false
				end

				if client.cam.type ~= "menu" then
					local players = Players:GetPlayers()
					-- table.sort(players, function(p1, p2)
					-- 	return table.find(menu.priority, p2.Name) ~= table.find(menu.priority, p1.Name) and table.find(menu.priority, p2.Name) == true and table.find(menu.priority, p1.Name) == false
					-- end)
					local cam = client.cam.cframe

					local priority_color = menu:GetVal("Visuals", "ESP Settings", "Highlight Priority", COLOR, true)
					local priority_alpha = menu:GetVal("Visuals", "ESP Settings", "Highlight Priority", COLOR)[4] / 255

					local friend_color = menu:GetVal("Visuals", "ESP Settings", "Highlight Friends", COLOR, true)
					local friend_alpha = menu:GetVal("Visuals", "ESP Settings", "Highlight Friends", COLOR)[4] / 255

					local target_color = menu:GetVal("Visuals", "ESP Settings", "Highlight Aimbot Target", COLOR, true)
					local target_alpha = menu:GetVal("Visuals", "ESP Settings", "Highlight Aimbot Target", COLOR)[4] / 255
					client.aliveplayers = 0
					for curplayer = 1, #players do
						
						
						local ply = players[curplayer]
						local plyname = ply.Name
						if client.hud:isplayeralive(ply) then
							local parts = client.replication.getbodyparts(ply)

							
							if not parts then
								continue
							end
							local resolvedPosition = ragebot:GetResolvedPosition(ply)
							local backtrackedPosition = ragebot:GetBacktrackedPosition(ply, parts, menu:GetVal("Rage", "Hack vs. Hack", "Backtracking Time")/1000)

							local GroupBox = "Team ESP"
							local enemy = false
							if ply.Team ~= LOCAL_PLAYER.Team then
								GroupBox = "Enemy ESP"
								enemy = true
								client.aliveplayers += 1
							end

							if not menu:GetVal("Visuals", GroupBox, "Enabled") then
								continue
							end
							
							ply.Character = parts.rootpart.Parent

							local torso = parts.torso.CFrame
							local rootpart = parts.rootpart.CFrame
							local position = torso.Position
							local resolved = false
							if menu:GetVal("Visuals", "Enemy ESP", "Flags")[3] then
								local newpos = ragebot:GetResolvedPosition(ply, parts)
								if newpos then
									resolved = true
								end
								position = newpos or position
							end
							--debug.profilebegin("renderVisuals Player ESP Box Calculation " .. plyname)

							local vTop = position + (torso.UpVector * 1.8) + cam.UpVector
							local vBottom = position - (torso.UpVector * 2.5) - cam.UpVector

							local top, topIsRendered = Camera:WorldToViewportPoint(vTop)
							local bottom, bottomIsRendered = Camera:WorldToViewportPoint(vBottom)
							
							if backtrackedPosition and menu:GetVal("Visuals", "Enemy ESP", "Show Backtrack Position") and enemy then 
								backtrackedPosition, btRendered = Camera:WorldToViewportPoint(backtrackedPosition.pos)
								if btRendered then
									allesp[11][1][curplayer].Position = Vector2.new(backtrackedPosition.x, backtrackedPosition.y)
									allesp[11][1][curplayer].NumSides = 12
									allesp[11][1][curplayer].Radius = 1 / backtrackedPosition.z * 100 + 3
									allesp[11][1][curplayer].Thickness = 1
									allesp[11][1][curplayer].Visible = true
									allesp[11][1][curplayer].Transparency = menu:GetVal("Visuals", "Enemy ESP", "Show Backtrack Position", COLOR)[4]/255
									allesp[11][1][curplayer].Color = menu:GetVal("Visuals", "Enemy ESP", "Show Backtrack Position", COLOR, true)
								end
							end

							-- local minY = math.abs(bottom.y - top.y)
							-- local sizeX = math.ceil(math.max(clamp(math.abs(bottom.x - top.x) * 2, 0, minY), minY / 2))
							-- local sizeY = math.ceil(math.max(minY, sizeX * 0.5))

							-- local boxSize = Vector2.new(sizeX, sizeY)
							local _width = math.floor(math.abs(top.x - bottom.x))
							local _height = math.floor(math.max(math.abs(bottom.y - top.y), _width / 2))
							local boxSize = Vector2.new(math.floor(math.max(_height / 1.5, _width)), _height)
							local boxPosition = Vector2.new(
								math.floor(top.x * 0.5 + bottom.x * 0.5 - boxSize.x * 0.5),
								math.floor(math.min(top.y, bottom.y))
							)

							--debug.profileend("renderVisuals Player ESP Box Calculation " .. plyname)

							local GroupBox = ply.Team == LOCAL_PLAYER.Team and "Team ESP" or "Enemy ESP"
							local health = math.ceil(client.hud:getplayerhealth(ply))
							local spoty = 0
							local boxtransparency = menu:GetVal("Visuals", GroupBox, "Box", COLOR2)[4] / 255
							local boxtransparencyfilled = menu:GetVal("Visuals", GroupBox, "Box", COLOR1)[4] / 255
							local espflags = menu:GetVal("Visuals", GroupBox, "Flags")
							local distance = math.floor((parts.rootpart.Position - Camera.CFrame.Position).Magnitude / 5)

							if (topIsRendered or bottomIsRendered) then
								if espflags[1] then
									local playerdata = teamdata[1]:FindFirstChild(plyname) or teamdata[2]:FindFirstChild(plyname)
									allesp[3][5][curplayer].Visible = true
									allesp[3][5][curplayer].Text = "lv".. playerdata.Rank.Text
									allesp[3][5][curplayer].Position = Vector2.new(
										math.floor(boxPosition.x) + boxSize.x + 2,
										math.floor(boxPosition.y) - 4 + spoty
									)
									spoty += 10
								end


								if espflags[2] then
									
									allesp[3][6][curplayer].Visible = true
									allesp[3][6][curplayer].Text = tostring(distance).. "m"
									allesp[3][6][curplayer].Position = Vector2.new(
										math.floor(boxPosition.x) + boxSize.x + 2,
										math.floor(boxPosition.y) - 4 + spoty
									)
									spoty += 10

								end

								if GroupBox == "Enemy ESP" then
									if espflags[3] then
										allesp[3][4][curplayer].Visible = resolved
										allesp[3][4][curplayer].Position = Vector2.new(
											math.floor(boxPosition.x) + boxSize.x + 2,
											math.floor(boxPosition.y) - 4 + spoty
										)
									end
								end
								if menu.options["Visuals"][GroupBox]["Name"][1] then
									--debug.profilebegin("renderVisuals Player ESP Render Name " .. plyname)

								
									local name = tostring(plyname)
									if menu.options["Visuals"]["ESP Settings"]["Text Case"][1] == 1 then
										name = string.lower(name)
									elseif menu.options["Visuals"]["ESP Settings"]["Text Case"][1] == 3 then
										name = string.upper(name)
									end

									allesp[4][1][curplayer].Text = name
									allesp[4][1][curplayer].Visible = true
									allesp[4][1][curplayer].Transparency = 1

									allesp[4][1][curplayer].Position = Vector2.new(boxPosition.x + boxSize.x * 0.5, boxPosition.y - 15)
								end

								if menu.options["Visuals"][GroupBox]["Box"][1] then
									--debug.profilebegin("renderVisuals Player ESP Render Box " .. plyname)
									for i = -1, 1 do
										local box = allesp[2][i + 3][curplayer]
										box.Visible = true
										box.Position = boxPosition + Vector2.new(i, i)
										box.Size = boxSize - Vector2.new(i * 2, i * 2)
										box.Transparency = boxtransparency

										if i ~= 0 then
											box.Color = RGB(20, 20, 20)
										end
										--box.Color = i == 0 and color or bColor:Add(bColor:Mult(color, 0.2), 0.1)
									end

									if boxtransparencyfilled ~= 0 then
										local box = allesp[2][1][curplayer]
										box.Visible = true
										box.Position = boxPosition
										box.Size = boxSize
										
										box.Transparency = boxtransparencyfilled
										box.Filled = true
									end
									--debug.profileend("renderVisuals Player ESP Render Box " .. plyname)
								end


								if menu.options["Visuals"][GroupBox]["Health Bar"][1] then
									--debug.profilebegin("renderVisuals Player ESP Render Health Bar " .. plyname)

									local ySizeBar = -math.floor(boxSize.y * health / 100)
									if menu.options["Visuals"][GroupBox]["Health Number"][1] and health <= menu.options["Visuals"]["ESP Settings"]["Max HP Visibility Cap"][1]
									then
										local hptext = allesp[3][3][curplayer]
										hptext.Visible = true
										hptext.Text = tostring(health)

										local tb = hptext.TextBounds

										-- clamp(ySizeBar + boxSize.y - tb.y * 0.5, -tb.y, boxSize.y - tb.y )
										hptext.Position = boxPosition + Vector2.new(
											-tb.x - 7,
											clamp(ySizeBar + boxSize.y - tb.y * 0.5, -4, boxSize.y - 10)
										)
										--hptext.Position = Vector2.new(boxPosition.x - 7 - tb.x, boxPosition.y + clamp(boxSize.y + ySizeBar - 8, -4, boxSize.y - 10))
										hptext.Color = menu:GetVal("Visuals", GroupBox, "Health Number", COLOR, true)
										hptext.Transparency = menu.options["Visuals"][GroupBox]["Health Number"][5][1][4] / 255


										--[[
								if menu:GetVal("Visuals", "Player ESP", "Health Number") then
									allesp.hptext[i].Text = tostring(health)
									local textsize = allesp.hptext[i].TextBounds
									allesp.hptext[i].Position = Vector2.new(boxtop.x - 7 - textsize.x, boxtop.y + clamp(boxsize.h + ySizeBar - 8, -4, boxsize.h - 10))
									allesp.hptext[i].Visible = true
								end
								]]
									end

									allesp[3][1][curplayer].Visible = true
									allesp[3][1][curplayer].Position = Vector2.new(math.floor(boxPosition.x) - 6, math.floor(boxPosition.y) - 1)
									allesp[3][1][curplayer].Size = Vector2.new(4, boxSize.y + 2)

									allesp[3][2][curplayer].Visible = true
									allesp[3][2][curplayer].Position = Vector2.new(
										math.floor(boxPosition.x) - 5,
										math.floor(boxPosition.y + boxSize.y)
									)

									allesp[3][2][curplayer].Size = Vector2.new(2, ySizeBar)

									allesp[3][2][curplayer].Color = ColorRange(health, {
										[1] = {
											start = 0,
											color = menu:GetVal("Visuals", GroupBox, "Health Bar", COLOR1, true),
										},
										[2] = {
											start = 100,
											color = menu:GetVal("Visuals", GroupBox, "Health Bar", COLOR2, true),
										},
									})

									--debug.profileend("renderVisuals Player ESP Render Health Bar " .. plyname)
								elseif menu.options["Visuals"][GroupBox]["Health Number"][1] and health <= menu.options["Visuals"]["ESP Settings"]["Max HP Visibility Cap"][1]
								then
									--debug.profilebegin("renderVisuals Player ESP Render Health Number " .. plyname)

									local hptext = allesp[3][3][curplayer]

									hptext.Visible = true
									hptext.Text = tostring(health)

									local tb = hptext.TextBounds

									hptext.Position = boxPosition + Vector2.new(-tb.x - 2, -4)
									hptext.Color = menu:GetVal("Visuals", GroupBox, "Health Number", COLOR, true)
									hptext.Transparency = menu.options["Visuals"][GroupBox]["Health Number"][5][1][4] / 255

									--debug.profileend("renderVisuals Player ESP Render Health Number " .. plyname)
								end

								local yaddpos = 0
								if menu.options["Visuals"][GroupBox]["Held Weapon"][1] then
									--debug.profilebegin("renderVisuals Player ESP Render Held Weapon " .. plyname)

									local charWeapon = _3pweps[ply]
									local wepname = charWeapon and charWeapon or "???"

									if menu.options["Visuals"]["ESP Settings"]["Text Case"][1] == 1 then
										wepname = string.lower(wepname)
									elseif menu.options["Visuals"]["ESP Settings"]["Text Case"][1] == 3 then
										wepname = string.upper(wepname)
									end

									local weptext = allesp[4][2][curplayer]
									
									weptext.Text = string_cut(
										wepname,
										menu:GetVal("Visuals", "ESP Settings", "Max Text Length")
									)
									weptext.Visible = true
									weptext.Position = Vector2.new(boxPosition.x + boxSize.x * 0.5, boxPosition.y + boxSize.y)

									yaddpos += 12
									--debug.profileend("renderVisuals Player ESP Render Held Weapon " .. plyname)
								end

								if menu:GetVal("Visuals", GroupBox, "Held Weapon Icon") then
									local charWeapon = _3pweps[ply]
									local wepname = charWeapon and charWeapon or "???"

									local tempicon = allesp[3][7][curplayer]

									local tempimage = gunicons[wepname]

									if (setwepicons[curplayer] ~= nil or wepname ~= "???") and tempimage ~= nil then
									
										local aspect_ratio = (tempimage[2]/4)/(tempimage[3]/4)
										local new_w = 19 * aspect_ratio
										tempicon.Visible = true
										tempicon.Position = Vector2.new(boxPosition.x + boxSize.x * 0.5 - (new_w/2), boxPosition.y + boxSize.y + yaddpos + 2)
										tempicon.Transparency = menu:GetVal("Visuals", GroupBox, "Held Weapon", COLOR)[4]/255
									
									elseif not menu:GetVal("Visuals", GroupBox, "Held Weapon") then

										if menu.options["Visuals"]["ESP Settings"]["Text Case"][1] == 1 then
											wepname = string.lower(wepname)
										elseif menu.options["Visuals"]["ESP Settings"]["Text Case"][1] == 3 then
											wepname = string.upper(wepname)
										end
	
										local weptext = allesp[4][2][curplayer]
										
										weptext.Text = string_cut(
											wepname,
											menu:GetVal("Visuals", "ESP Settings", "Max Text Length")
										)
										weptext.Visible = true
										weptext.Position = Vector2.new(boxPosition.x + boxSize.x * 0.5, boxPosition.y + boxSize.y)
	
									end
									
									

									if setwepicons[curplayer] ~= wepname then
										print(wepname, tostring(tempimage))
										if tempimage ~= nil then
											local aspect_ratio = (tempimage[2]/4)/(tempimage[3]/4)
											local new_w = 19 * aspect_ratio

											tempicon.Data = syn.crypt.base64.decode(tempimage[1])
											tempicon.Size = Vector2.new(new_w, 19)
										end
										setwepicons[curplayer] = wepname
									end
									
								end

								-- if menu.options["Visuals"][GroupBox]["Distance"][1] then
								-- 	--debug.profilebegin("renderVisuals Player ESP Render Distance " .. plyname)

								-- 	local disttext = allesp[4][3][curplayer]

								-- 	disttext.Text = tostring(distance) .. "m"
								-- 	disttext.Visible = true
								-- 	disttext.Position = Vector2.new(
								-- 		boxPosition.x + boxSize.x * 0.5,
								-- 		boxPosition.y + boxSize.y + spoty
								-- 	)

								-- 	--debug.profileend("renderVisuals Player ESP Render Distance " .. plyname)
								-- end

								if menu.options["Visuals"][GroupBox]["Skeleton"][1] then
									--debug.profilebegin("renderVisuals Player ESP Render Skeleton" .. plyname)

									local torso = Camera:WorldToViewportPoint(ply.Character.Torso.Position)
									for i = 1, #skelparts do
										
										local line = allesp[1][i][curplayer]

										local posie = Camera:WorldToViewportPoint(ply.Character:FindFirstChild(skelparts[i]).Position)
										line.From = Vector2.new(posie.x, posie.y)
										line.To = Vector2.new(torso.x, torso.y)
										line.Visible = true
									end
									--debug.profileend("renderVisuals Player ESP Render Skeleton" .. plyname)
								end
								--da colourz !!! :D 🔥🔥🔥🔥

								if menu:GetVal("Visuals", "ESP Settings", "Highlight Priority") and table.find(menu.priority, plyname) then
									allesp[4][1][curplayer].Color = priority_color
									allesp[4][1][curplayer].Transparency = priority_alpha

									allesp[2][3][curplayer].Color = priority_color
									allesp[2][1][curplayer].Color = priority_color

									allesp[4][2][curplayer].Color = priority_color
									allesp[4][2][curplayer].Transparency = priority_alpha

									for i = 1, #skelparts do
										local line = allesp[1][i][curplayer]
										line.Color = priority_color
										line.Transparency = priority_alpha
									end
								elseif menu:GetVal("Visuals", "ESP Settings", "Highlight Friends") and table.find(menu.friends, plyname)
								then
									allesp[4][1][curplayer].Color = friend_color
									allesp[4][1][curplayer].Transparency = friend_alpha

									allesp[2][1][curplayer].Color = friend_color
									allesp[2][3][curplayer].Color = friend_color

									allesp[4][2][curplayer].Color = friend_color
									allesp[4][2][curplayer].Transparency = friend_alpha

									for i = 1, #skelparts do
										local line = allesp[1][i][curplayer]
										line.Color = friend_color
										line.Transparency = friend_alpha
									end
								elseif menu:GetVal("Visuals", "ESP Settings", "Highlight Aimbot Target") and (
										ply == legitbot.target or ply == ragebot.target
									)
								then
									allesp[4][1][curplayer].Color = target_color
									allesp[4][1][curplayer].Transparency = target_alpha

									allesp[2][3][curplayer].Color = target_color
									allesp[2][1][curplayer].Color = target_color

									allesp[4][2][curplayer].Color = target_color
									allesp[4][2][curplayer].Transparency = target_alpha

									for i = 1, #skelparts do
										local line = allesp[1][i][curplayer]
										line.Color = target_color
										line.Transparency = target_alpha
									end
								else
									allesp[4][1][curplayer].Color = menu:GetVal("Visuals", GroupBox, "Name", COLOR, true) -- RGB(menu.options["Visuals"][GroupBox]["Name"][5][1][1], menu.options["Visuals"][GroupBox]["Name"][5][1][2], menu.options["Visuals"][GroupBox]["Name"][5][1][3])
									allesp[4][1][curplayer].Transparency = menu:GetVal("Visuals", GroupBox, "Name", COLOR)[4] / 255

									allesp[2][3][curplayer].Color = menu:GetVal("Visuals", GroupBox, "Box", COLOR2, true)
									allesp[2][1][curplayer].Color = menu:GetVal("Visuals", GroupBox, "Box", COLOR1, true)

									allesp[4][2][curplayer].Color = menu:GetVal("Visuals", GroupBox, "Held Weapon", COLOR, true)
									allesp[4][2][curplayer].Transparency = menu:GetVal("Visuals", GroupBox, "Held Weapon", COLOR)[4] / 255

									for i = 1, #skelparts do
										local line = allesp[1][i][curplayer]
										line.Color = menu:GetVal("Visuals", GroupBox, "Skeleton", COLOR, true)
										line.Transparency = menu:GetVal("Visuals", GroupBox, "Skeleton", COLOR)[4] / 255
									end
								end
							elseif GroupBox == "Enemy ESP" and menu:GetVal("Visuals", "Enemy ESP", "Out of View")
							then
								--debug.profilebegin("renderVisuals Player ESP Render Out of View " .. plyname)
								local color = menu:GetVal("Visuals", "Enemy ESP", "Out of View", COLOR, true)
								local color2 = bColor:Add(bColor:Mult(color, 0.2), 0.1)
								if menu:GetVal("Visuals", "ESP Settings", "Highlight Priority") and table.find(menu.priority, plyname)
								then
									color = menu:GetVal(
											"Visuals",
											"ESP Settings",
											"Highlight Priority",
											COLOR,
											true
										)
									color2 = bColor:Mult(color, 0.6)
								elseif menu:GetVal("Visuals", "ESP Settings", "Highlight Friends", COLOR) and table.find(menu.friends, plyname)
								then
									color = menu:GetVal(
											"Visuals",
											"ESP Settings",
											"Highlight Friends",
											COLOR,
											true
										)
									color2 = bColor:Mult(color, 0.6)
								elseif menu:GetVal("Visuals", "ESP Settings", "Highlight Aimbot Target") and (
										ply == legitbot.target or ply == ragebot.target
									)
								then
									color = menu:GetVal(
										"Visuals",
										"ESP Settings",
										"Highlight Aimbot Target",
										COLOR,
										true
									)
									color2 = bColor:Mult(color, 0.6)
								end
								for i = 1, 2 do
									local Tri = allesp[5][i][curplayer]

									local rootpartpos = ply.Character.HumanoidRootPart.Position -- these HAVE to move now theres no way

									Tri.Visible = true

									local relativePos = Camera.CFrame:PointToObjectSpace(rootpartpos)
									local direction = math.atan2(-relativePos.y, relativePos.x)

									local distance = dot(relativePos.Unit, relativePos)
									local arrow_size = menu:GetVal("Visuals", "Enemy ESP", "Dynamic Arrow Size") and map(distance, 1, 100, 50, 15) or 15
									arrow_size = arrow_size > 50 and 50 or arrow_size < 15 and 15 or arrow_size

									direction = Vector2.new(math.cos(direction), math.sin(direction))

									local pos = (
											direction  * SCREEN_SIZE.y  * menu:GetVal("Visuals", "Enemy ESP", "Arrow Distance") / 200
										) + (SCREEN_SIZE * 0.5)

									Tri.PointA = pos
									Tri.PointB = pos - bVector2:getRotate(direction, 0.5) * arrow_size
									Tri.PointC = pos - bVector2:getRotate(direction, -0.5) * arrow_size

									Tri.Color = i == 1 and color or color2
									Tri.Transparency = menu:GetVal("Visuals", "Enemy ESP", "Out of View", COLOR)[4] / 255
								end
								--debug.profileend("renderVisuals Player ESP Render Out of View " .. plyname)
							end
						end
					end

					--ANCHOR weapon esp
					if menu:GetVal("Visuals", "Dropped ESP", "Weapon Names") or menu:GetVal("Visuals", "Dropped ESP", "Weapon Ammo") or menu:GetVal("Visuals", "Dropped ESP", "Weapon Icons") then
						--debug.profilebegin("renderVisuals Dropped 1ESP")
						local gunnum = 0
						local dropped = workspace.Ignore.GunDrop:GetChildren()
						local wepadd = menu:GetVal("Visuals", "Dropped ESP", "Weapon Names") and 5 or 13
						for k = 1, #dropped do
							local v = dropped[k]
							if not client then
								return
							end
							if v.Name == "Dropped" then
								local slot = v:FindFirstChild("Slot1")
								if not slot then
									continue
								end
								local gunpos = slot.Position
								local gun_dist = (gunpos - client.cam.cframe.p).Magnitude
								if gun_dist < 80 then
									local hasgun = false
									local gunpos2d, gun_on_screen = workspace.CurrentCamera:WorldToScreenPoint(gunpos)
									local children = v:GetChildren()
									for k1 = 1, #children do
										local v1 = children[k1]
										if tostring(v1) == "Gun" then
											hasgun = true
											break
										end
									end

									if gun_on_screen and gunnum <= 50 and hasgun then
										gunnum = gunnum + 1
										local gunclearness = 1
										if gun_dist >= 50 then
											local closedist = gun_dist - 50
											gunclearness = 1 - (1 * closedist / 30)
										end

										if menu:GetVal("Visuals", "Dropped ESP", "Weapon Icons") then
											local tempimage = gunicons[v.Gun.Value]

											if tempimage ~= nil then
												local aspect_ratio = (tempimage[2]/4)/(tempimage[3]/4)
												local new_w = 19 * aspect_ratio

												wepesp[3][gunnum].Data = syn.crypt.base64.decode(tempimage[1])
												wepesp[3][gunnum].Size = Vector2.new(new_w, 19)
												wepesp[3][gunnum].Visible = true
												wepesp[3][gunnum].Position = Vector2.new(math.floor(gunpos2d.x) - new_w/2, math.floor(gunpos2d.y + (wepadd) ))
												wepesp[3][gunnum].Transparency = menu:GetVal("Visuals", "Dropped ESP", "Weapon Names", COLOR1)[4] * gunclearness / 255
											elseif not menu:GetVal("Visuals", "Dropped ESP", "Weapon Names") then
												if client.logic.currentgun and client.logic.currentgun and client.logic.currentgun.data and v.Gun.Value == client.logic.currentgun.data.name
												then
													wepesp[1][gunnum].Color = menu:GetVal(
														"Visuals",
														"Dropped ESP",
														"Weapon Names",
														COLOR1,
														true
													)
													wepesp[1][gunnum].Transparency = menu:GetVal(
															"Visuals",
															"Dropped ESP",
															"Weapon Names",
															COLOR1
														)[4]  * gunclearness / 255
												else
													wepesp[1][gunnum].Color = menu:GetVal(
														"Visuals",
														"Dropped ESP",
														"Weapon Names",
														COLOR2,
														true
													)
													wepesp[1][gunnum].Transparency = menu:GetVal(
															"Visuals",
															"Dropped ESP",
															"Weapon Names",
															COLOR2
														)[4]  * gunclearness / 255
												end
												wepesp[1][gunnum].Text = v.Gun.Value
												wepesp[1][gunnum].Visible = true
												wepesp[1][gunnum].Position = Vector2.new(math.floor(gunpos2d.x), math.floor(gunpos2d.y + 25))
											end
											--menu:GetVal("Visuals", "Dropped ESP", "Weapon Names", COLOR1)[4]  * gunclearness / 255
										end

										if menu:GetVal("Visuals", "Dropped ESP", "Weapon Names") then
											if client.logic.currentgun and client.logic.currentgun and client.logic.currentgun.data and v.Gun.Value == client.logic.currentgun.data.name
											then
												wepesp[1][gunnum].Color = menu:GetVal(
													"Visuals",
													"Dropped ESP",
													"Weapon Names",
													COLOR1,
													true
												)
												wepesp[1][gunnum].Transparency = menu:GetVal(
														"Visuals",
														"Dropped ESP",
														"Weapon Names",
														COLOR1
													)[4]  * gunclearness / 255
											else
												wepesp[1][gunnum].Color = menu:GetVal(
													"Visuals",
													"Dropped ESP",
													"Weapon Names",
													COLOR2,
													true
												)
												wepesp[1][gunnum].Transparency = menu:GetVal(
														"Visuals",
														"Dropped ESP",
														"Weapon Names",
														COLOR2
													)[4]  * gunclearness / 255
											end
											wepesp[1][gunnum].Text = v.Gun.Value
											wepesp[1][gunnum].Visible = true
											wepesp[1][gunnum].Position = Vector2.new(math.floor(gunpos2d.x), math.floor(gunpos2d.y + 25))
										end
										if menu:GetVal("Visuals", "Dropped ESP", "Weapon Ammo") then
											if v:FindFirstChild("Spare") then
												wepesp[2][gunnum].Text = "[ " .. tostring(v.Spare.Value) .. " ]"
											end
											wepesp[2][gunnum].Color = menu:GetVal(
													"Visuals",
													"Dropped ESP",
													"Weapon Ammo",
													COLOR,
													true
												)
											wepesp[2][gunnum].Transparency = menu:GetVal("Visuals", "Dropped ESP", "Weapon Ammo", COLOR)[4]  * gunclearness / 255
											wepesp[2][gunnum].Visible = true
											wepesp[2][gunnum].Position = Vector2.new(math.floor(gunpos2d.x), math.floor(gunpos2d.y + 36))
										end
									end
								end
							end
						end
						--debug.profileend("renderVisuals Dropped ESP")
					end
					if menu:GetVal("Visuals", "FOV", "Enabled") then -- fov circles
						local fovcircles = allesp[9]
						if menu:GetVal("Visuals", "FOV", "Aim Assist") then
							local col = menu:GetVal("Visuals", "FOV", "Aim Assist", COLOR, true)
							local transparency = menu:GetVal("Visuals", "FOV", "Aim Assist", COLOR)[4] / 255
							for i = 1, 2 do
								local circle = fovcircles[1][i]
								circle.Color = i == 2 and col or Color3.new(0, 0, 0)
								circle.Transparency = transparency / (i == 1 and 2 or 1)
								circle.Thickness = i == 2 and 1 or 3
								circle.Radius = menu:GetVal("Legit", "Aim Assist", "Aimbot FOV") / workspace.CurrentCamera.FieldOfView  * SCREEN_SIZE.y
								circle.Visible = true
								circle.Position = SCREEN_SIZE / 2
							end
						else
							for i = 1, 2 do
								local circle = fovcircles[1][i]
								circle.Visible = false
							end
						end
						if menu:GetVal("Visuals", "FOV", "Aim Assist Deadzone") then
							local col = menu:GetVal("Visuals", "FOV", "Aim Assist Deadzone", COLOR, true)
							local transparency = menu:GetVal("Visuals", "FOV", "Aim Assist Deadzone", COLOR)[4] / 255
							for i = 1, 2 do
								local circle = fovcircles[2][i]
								circle.Color = i == 2 and col or Color3.new(0, 0, 0)
								circle.Transparency = transparency / (i == 1 and 2 or 1)
								circle.Thickness = i == 2 and 1 or 3
								circle.Radius = menu:GetVal("Legit", "Aim Assist", "Deadzone FOV") / workspace.CurrentCamera.FieldOfView  * SCREEN_SIZE.y
								circle.Position = SCREEN_SIZE / 2
								circle.Visible = true
							end
						else
							for i = 1, 2 do
								local circle = fovcircles[2][i]
								circle.Visible = false
							end
						end
						if menu:GetVal("Visuals", "FOV", "Bullet Redirection") then
							local col = menu:GetVal("Visuals", "FOV", "Bullet Redirection", COLOR, true)
							local transparency = menu:GetVal("Visuals", "FOV", "Bullet Redirection", COLOR)[4] / 255
							for i = 1, 2 do
								local circle = fovcircles[3][i]
								circle.Color = i == 2 and col or Color3.new(0, 0, 0)
								circle.Transparency = transparency / (i == 1 and 2 or 1)
								circle.Thickness = i == 2 and 1 or 3
								circle.Radius = menu:GetVal("Legit", "Bullet Redirection", "Silent Aim FOV") / workspace.CurrentCamera.FieldOfView  * SCREEN_SIZE.y
								circle.Position = SCREEN_SIZE / 2
								circle.Visible = true
							end
						else
							for i = 1, 2 do
								local circle = fovcircles[3][i]
								circle.Visible = false
							end
						end
						local circle = fovcircles[4]
						if menu:GetVal("Visuals", "FOV", "Ragebot") then
							local col = menu:GetVal("Visuals", "FOV", "Ragebot", COLOR, true)
							local transparency = menu:GetVal("Visuals", "FOV", "Ragebot", COLOR)[4] / 255
							for i = 1, 2 do
								local circle = fovcircles[4][i]
								circle.Color = i == 2 and col or Color3.new(0, 0, 0)
								circle.Transparency = transparency / (i == 1 and 2 or 1)
								circle.Thickness = i == 2 and 1 or 3
								circle.Position = SCREEN_SIZE / 2
								circle.Radius = menu:GetVal("Rage", "Aimbot", "Aimbot FOV") / workspace.CurrentCamera.FieldOfView  * SCREEN_SIZE.y
								circle.Visible = true
							end
						else
							for i = 1, 2 do
								local circle = fovcircles[4][i]
								circle.Visible = false
							end
						end
					end

					--debug.profilebegin("renderVisuals Dropped ESP Grenade Warning")
					if menu:GetVal("Visuals", "Dropped ESP", "Grenade Warning") then
						local health = client.char:gethealth()
						local color1 = menu:GetVal("Visuals", "Dropped ESP", "Grenade Warning", COLOR, true)
						local color2 = RGB(
							menu:GetVal("Visuals", "Dropped ESP", "Grenade Warning", COLOR)[1] - 20,
							menu:GetVal("Visuals", "Dropped ESP", "Grenade Warning", COLOR)[2] - 20,
							menu:GetVal("Visuals", "Dropped ESP", "Grenade Warning", COLOR)[3] - 20
						)
						for i = 1, #menu.activenades do
							local nade = menu.activenades[i]
							local headpos = client.char.alive and client.cam.cframe.p or Vector3.new()
							local delta = (nade.blowupat - headpos)
							local nade_dist = dot(delta.Unit, delta)
							local nade_percent = (tick() - nade.start) / (nade.blowuptick - nade.start)

							if nade_dist <= 80 then
								local nadepos, nade_on_screen = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(nade.blowupat.x, nade.blowupat.y, nade.blowupat.z))

								if not nade_on_screen then
									local relativePos = Camera.CFrame:PointToObjectSpace(nade.blowupat)
									local angle = math.atan2(-relativePos.y, relativePos.x)
									local ox = math.cos(angle)
									local oy = math.sin(angle)
									local slope = oy / ox

									local h_edge = SCREEN_SIZE.x - 36
									local v_edge = SCREEN_SIZE.y - 72
									if oy < 0 then
										v_edge = 0
									end
									if ox < 0 then
										h_edge = 36
									end
									local y = (slope * h_edge) + (SCREEN_SIZE.y / 2) - slope * (SCREEN_SIZE.x / 2)
									if y > 0 and y < SCREEN_SIZE.y - 72 then
										nadepos = Vector2.new(h_edge, y)
									else
										nadepos = Vector2.new(
											(v_edge - SCREEN_SIZE.y / 2 + slope * (SCREEN_SIZE.x / 2)) / slope,
											v_edge
										)
									end
								end
								--
								nade_esp[1][i].Visible = true
								nade_esp[1][i].Position = Vector2.new(math.floor(nadepos.x), math.floor(nadepos.y + 36))

								nade_esp[2][i].Visible = true
								nade_esp[2][i].Position = Vector2.new(math.floor(nadepos.x), math.floor(nadepos.y + 36))

								nade_esp[4][i].Visible = true
								nade_esp[4][i].Position = Vector2.new(math.floor(nadepos.x) - 10, math.floor(nadepos.y + 10))

								nade_esp[3][i].Visible = true
								nade_esp[3][i].Position = Vector2.new(math.floor(nadepos.x), math.floor(nadepos.y + 36))

								local d0 = 250 -- max damage
								local d1 = 15 -- min damage
								local r0 = 8 -- maximum range before the damage starts dropping off due to distance
								local r1 = 30 -- minimum range i think idk

								local damage = nade_dist < r0 and d0 or nade_dist < r1 and (d1 - d0) / (r1 - r0) * (nade_dist - r0) + d0 or 0

								local wall
								if damage > 0 then
									wall = workspace:FindPartOnRayWithWhitelist(
										Ray.new(headpos, (nade.blowupat - headpos)),
										client.roundsystem.raycastwhitelist
									)
									if wall then
										damage = 0
									end
								end

								local str = damage == 0 and "Safe" or damage >= health and "LETHAL" or string.format("-%d hp", damage)
								nade_esp[3][i].Text = str

								nade_esp[1][i].Color = ColorRange(damage, {
									[1] = { start = 15, color = RGB(20, 20, 20) },
									[2] = { start = health, color = RGB(150, 20, 20) },
								})

								nade_esp[2][i].Color = ColorRange(damage, {
									[1] = { start = 15, color = RGB(50, 50, 50) },
									[2] = { start = health, color = RGB(220, 20, 20) },
								})

								nade_esp[5][i].Visible = true
								nade_esp[5][i].Position = Vector2.new(math.floor(nadepos.x) - 16, math.floor(nadepos.y + 50))

								nade_esp[6][i].Visible = true
								nade_esp[6][i].Position = Vector2.new(math.floor(nadepos.x) - 15, math.floor(nadepos.y + 51))

								nade_esp[7][i].Visible = true
								nade_esp[7][i].Size = Vector2.new(30 * (1 - nade_percent), 2)
								nade_esp[7][i].Position = Vector2.new(math.floor(nadepos.x) - 15, math.floor(nadepos.y + 51))
								nade_esp[7][i].Color = color1

								nade_esp[8][i].Visible = true
								nade_esp[8][i].Size = Vector2.new(30 * (1 - nade_percent), 2)
								nade_esp[8][i].Position = Vector2.new(math.floor(nadepos.x) - 15, math.floor(nadepos.y + 53))
								nade_esp[8][i].Color = color2

								local tranz = 1
								if nade_dist >= 50 then
									local closedist = nade_dist - 50
									tranz = 1 - (1 * closedist / 30)
								end

								for j = 1, #nade_esp do
									nade_esp[j][i].Transparency = tranz
								end
							end
						end
					end

					--debug.profileend("renderVisuals Dropped ESP Grenade Warning")

					--debug.profilebegin("renderVisuals Local Visuals")
					misc.setvis = misc.setvis or {} -- this is for caching the weapons and shit so that when you switche weapons it will execute this code :3
					-- hand chams and such
					if not client then
						return
					end
					local vm = workspace.Camera:GetChildren()
					local armcham = menu:GetVal("Visuals", "Local", "Arm Chams")
					local armmaterial = menu:GetVal("Visuals", "Local", "Arm Material")

					for k, v in pairs(vm) do
						if v.Name == "Left Arm" or v.Name == "Right Arm" then
							for k1, v1 in pairs(v:GetChildren()) do
								if armcham then
									v1.Color = menu:GetVal("Visuals", "Local", "Arm Chams", COLOR2, true)
								end
								if v1.Transparency ~= 1 then
									if armcham then
										if not client.fakecharacter then
											
											v1.Transparency = 0.999999 + (
													menu:GetVal("Visuals", "Local", "Arm Chams", COLOR2)[4] / -255
												)
										else
											v1.Transparency = 0.999999
										end
									else
										if not client.fakecharacter then
											v1.Transparency = 0
										else
											v1.Transparency = 0.999999
										end
									end
								end
								v1.Material = mats[armmaterial]
								if v1.ClassName == "MeshPart" or v1.Name == "Sleeve" then
									if armcham then
										v1.Color = menu:GetVal("Visuals", "Local", "Arm Chams", COLOR1, true)
									end
									if v1.Transparency ~= 1 then
										if armcham then
											if not client.fakecharacter then
												v1.Transparency = 0.999999 + (
														menu:GetVal("Visuals", "Local", "Arm Chams", COLOR1)[4] / -255
													)
											else
												v1.Transparency = 0.999999
											end
										else
											if not client.fakecharacter then
												v1.Transparency = 0
											else
												v1.Transparency = 0.999999
											end
										end
									end
									if armcham then
										if v1.TextureID and tostring(material) ~= "ForceField" then
											v1.TextureID = ""
										else
											v1.TextureID = "rbxassetid://2163189692"
										end
										v1:ClearAllChildren()
									end
								end
							end
						end
					end
					local wepcham = menu:GetVal("Visuals", "Local", "Weapon Chams")

					for k, v in pairs(vm) do
						if v.Name ~= "Left Arm" and v.Name ~= "Right Arm" and v.Name ~= "FRAG" then
							for k1, v1 in pairs(v:GetChildren()) do
								if wepcham then
									v1.Color = menu:GetVal("Visuals", "Local", "Weapon Chams", COLOR1, true)
								end
								if v1.Transparency ~= 1 then
									if wepcham then
										if not client.fakecharacter then
											v1.Transparency = 0.999999 + (
													menu:GetVal("Visuals", "Local", "Weapon Chams", COLOR1)[4] / -255
												)
										else
											v1.Transparency = 0.999999
										end
									else
										if not client.fakecharacter then
											v1.Transparency = client.logic.currentgun.transparencydata and client.logic.currentgun.transparencydata[v1] or 0
										else
											v1.Transparency = 0.999999
										end
									end
								end
								-- if v1.Transparency ~= 1 then
								-- 	v1.Transparency = 0.99999 + (menu:GetVal("Visuals", "Local", "Weapon Chams", COLOR1)[4]/-255) --- it works shut up + i don't wanna make a fucking table for this shit
								-- end
								if menu:GetVal("Visuals", "Local", "Remove Weapon Skin") and wepcham then
									for i2, v2 in pairs(v1:GetChildren()) do
										if v2.ClassName == "Texture" or v2.ClassName == "Decal" then
											v2:Destroy()
										end
									end
								end

								local mat = mats[menu:GetVal("Visuals", "Local", "Weapon Material")]
								if wepcham then
									v1.Material = mat
								end

								if v1:IsA("UnionOperation") and wepcham then
									v1.UsePartColor = true
								end

								if v1.ClassName == "MeshPart" and wepcham then
									v1.TextureID = mat == "ForceField" and "rbxassetid://5843010904" or ""
								end

								if v1.Name == "LaserLight" and wepcham then
									local transparency = 1 + (
											menu:GetVal("Visuals", "Local", "Weapon Chams", COLOR2)[4] / -255
										)
									v1.Color = menu:GetVal("Visuals", "Local", "Weapon Chams", COLOR2, true)
									v1.Transparency = (transparency / 2) + 0.5
									v1.Material = "ForceField"
								elseif v1.Name == "SightMark" and wepcham then
									if v1:FindFirstChild("SurfaceGui") then
										local color = menu:GetVal("Visuals", "Local", "Weapon Chams", COLOR2, true)
										local transparency = 1 + (
												menu:GetVal("Visuals", "Local", "Weapon Chams", COLOR2)[4] / -255
											)
										v1.SurfaceGui.Border.Scope.ImageColor3 = color
										v1.SurfaceGui.Border.Scope.ImageTransparency = transparency
										if v1.SurfaceGui:FindFirstChild("Margins") then
											v1.SurfaceGui.Margins.BackgroundColor3 = color
											v1.SurfaceGui.Margins.ImageColor3 = color
											v1.SurfaceGui.Margins.ImageTransparency = (transparency / 5) + 0.7
										elseif v1.SurfaceGui:FindFirstChild("Border") then
											v1.SurfaceGui.Border.BackgroundColor3 = color
											v1.SurfaceGui.Border.ImageColor3 = color
											v1.SurfaceGui.Border.ImageTransparency = 1
										end
									end
								end
							end
						end
					end
					--debug.profileend("renderVisuals Local Visuals")
				end
				if menu:GetVal("Visuals", "Keybinds", "Enabled") then-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					local texts = allesp[10]-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					local listsizes = menu:GetVal("Visuals", "Keybinds", "Use List Sizes")-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					local posy = math.ceil(SCREEN_SIZE.y * menu:GetVal("Visuals", "Keybinds", "Keybinds List Y") / 100)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					local margin = posy-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					local posx = math.ceil(math.max(menu.stat_menu and 330 or 10, SCREEN_SIZE.x * menu:GetVal("Visuals", "Keybinds", "Keybinds List X") / 100))-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					local col = menu:GetVal("Visuals", "Keybinds", "Enabled", COLOR, true)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					local transparency = menu:GetVal("Visuals", "Keybinds", "Enabled", COLOR)[4] / 255-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					local newtexts = {}-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					for i = 1, #menu.keybinds do-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local keybind = menu.keybinds[i]-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local box1 = texts[1][i]-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local box = texts[2][i]-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local box2 = texts[3][i]-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local box3 = texts[5][i]-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local text = texts[4][i]-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						if keybind and keybind[1] and menu:GetVal(keybind[4], keybind[3], keybind[2]) and menu:GetKey(keybind[4], keybind[3], keybind[2])-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						then-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							table.insert(newtexts, keybind[3] .. ": " .. keybind[2])-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						text.Visible = false-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						if box then-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							box.Visible = false-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box1.Visible = false-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box2.Visible = false-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box3.Visible = false-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					table.sort(newtexts, function(s, s1)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						return #s > #s1-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					end) -- i hate this shit-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					table.insert(newtexts, 1, "Keybinds")-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					local maxwidth = Vector2.new(0, 0)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					local maxwidth2 = Vector2.new(0, 0)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					for i = 1, #newtexts do-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local text = texts[4][i]-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						text.Center = false-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						text.Text = newtexts[i]-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						if i <= 1 then-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							local newthing = Vector2.new(text.TextBounds.x + 4, text.TextBounds.y)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							if newthing.x > maxwidth.x then-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
								maxwidth = newthing-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						if i <= 2 then-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							local newthing = Vector2.new(text.TextBounds.x + 4, text.TextBounds.y)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							if newthing.x > maxwidth2.x then-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
								maxwidth2 = newthing - maxwidth-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					for i = 1, #newtexts do-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local box1 = texts[1][i]-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local box3 = texts[5][i]-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local box = texts[3][i]-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local text = texts[4][i]-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						text.Position = Vector2.new(posx + 2, margin)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						text.Color = i ~= 1 and col or Color3.new(1, 1, 1)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						text.Transparency = transparency-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						text.Visible = true-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box.Position = Vector2.new(posx, margin)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box.Visible = true-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box1.Position = Vector2.new(posx - 1, margin - 3)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box1.Visible = true-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box1.Color = Color3.new(0, 0, 0)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box3.Visible = true-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box3.Color = Color3.new(0, 0, 0)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box3.Transparency = 0.4-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						if listsizes then-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							local w = 8
							local h = 15
							if i == 1 then
								h = 9 * #newtexts
								w = 8 
							end
							if i == #newtexts then
								h += 7
							end
							local x = posx - 2
							local y = margin - 4
							-- if i == 2 then
							-- 	x += 4
							-- 	w -= 4
							-- end
							box.Size = text.TextBounds + Vector2.new(4, 3)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							box1.Size = text.TextBounds + Vector2.new(6, 7)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							box3.Size = Vector2.new(text.TextBounds.x + w, h) -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							box3.Position = Vector2.new(x, y) -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						else-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							box.Size = maxwidth + maxwidth2 + Vector2.new(0, 3)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							box1.Size = maxwidth + maxwidth2 + Vector2.new(2, 7)-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							box3.Size = maxwidth + maxwidth2 + Vector2.new(4, (i == #newtexts and i == 1) and 9 or i == #newtexts and 4 or i == 1 and 6 or 3) -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							box3.Position = Vector2.new(posx - 2, (i == 1) and margin - 4 or i == #newtexts and margin + 1 or margin) -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						margin += 15-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					for i = 1, 15 do-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local box = texts[2][i] -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box.Position = Vector2.new(posx, posy + i - 1) -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box.Size = Vector2.new(maxwidth.x + ((not listsizes) and maxwidth2.x or 0), 1) -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box.Visible = true -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					for i = 1, 2 do-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local k = i + 15 -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local box = texts[2][k] -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						local color = (menu:GetVal("Settings", "Cheat Settings", "Menu Accent") and menu:GetVal("Settings", "Cheat Settings", "Menu Accent", COLOR, true) or Color3.fromRGB(127, 72, 163))-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						color = i == 1 and color or Color3.fromRGB(color.R * 255 - 40, color.G * 255 - 40, color.B * 255 - 40) -- super shit-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box.Color = color -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box.Position = Vector2.new(posx, posy + i - 3) -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box.Size = Vector2.new(maxwidth.x+((not listsizes) and maxwidth2.x or 0), 1) -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						box.Visible = true -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					if listsizes then-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						for i = 1, 2 do -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							local k = i + 17 -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							local box = texts[2][k] -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							local color = (menu:GetVal("Settings", "Cheat Settings", "Menu Accent") and menu:GetVal("Settings", "Cheat Settings", "Menu Accent", COLOR, true) or Color3.fromRGB(127, 72, 163))-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							color = i == 1 and color or Color3.fromRGB(color.R * 255 - 40, color.G * 255 - 40, color.B * 255 - 40) -- super shit-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							box.Color = color -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							box.Position = Vector2.new(posx+maxwidth.x + 1, posy + i + 12) -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							box.Size = Vector2.new(maxwidth2.x - 1, 1) -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
							box.Visible = maxwidth2.x ~= 0 -- this is fucking stupid i hate this. why did i do this-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
						end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
					end-- THIS IS FUCKING STUPID I HATE THIS. WHY DID I DO THIS
				end
				--debug.profileend("renderVisuals Main")
				--debug.profilebegin("renderVisuals No Scope")
				do -- no scope pasted from v1 lol
					local gui = LOCAL_PLAYER.PlayerGui
					local frame = gui.MainGui.ScopeFrame
					if menu:GetVal("Visuals", "Camera Visuals", "No Scope Border") and frame then
						local sightRear = frame:FindFirstChild("SightRear")
						if sightRear then
							local children = sightRear:GetChildren()
							for i = 1, #children do
								local thing = children[i]
								if thing.ClassName == "Frame" then
									thing.Visible = false
								end
							end
							frame.SightFront.Visible = false
							sightRear.ImageTransparency = 1
						end
					elseif frame then
						if sightRear then
							local children = sightRear:GetChildren()
							for i = 1, #children do
								local thing = children[i]
								if thing.ClassName == "Frame" then
									thing.Visible = true
								end
							end
							frame.SightFront.Visible = true
							sightRear.ImageTransparency = 0
						end
					end
				end
				--debug.profileend("renderVisuals No Scope")
			end

			menu.connections.deadbodychildadded = workspace.Ignore.DeadBody.ChildAdded:Connect(function(newchild)
				if menu:GetVal("Visuals", "Misc", "Ragdoll Chams") then
					local children = newchild:GetChildren()
					for i = 1, #children do
						local curvalue = children[i]

						if not curvalue:IsA("Model") and curvalue.Name ~= "Humanoid" then
							matname = mats[menu:GetVal("Visuals", "Misc", "Ragdoll Material")]

							curvalue.Material = Enum.Material[matname]

							curvalue.Color = menu:GetVal("Visuals", "Misc", "Ragdoll Chams", COLOR, true)
							local vertexcolor = Vector3.new(curvalue.Color.R, curvalue.Color.G, curvalue.Color.B)
							local mesh = curvalue:FindFirstChild("Mesh")
							if mesh then
								mesh.VertexColor = vertexcolor -- color da texture baby  ! ! ! ! ! 👶👶
								-- DA BABY????? WTF
							end

							if curvalue:IsA("Pants") then
								curvalue:Destroy()
							end

							local pant = curvalue:FindFirstChild("Pant")
							if pant then
								pant:Destroy()
							end
							if mesh then
								mesh:Destroy()
							end
						end
					end
				end
			end)

			menu.connections.dropweaponadded = workspace.Ignore.GunDrop.ChildAdded:Connect(function(newchild)
				if menu:GetVal("Visuals", "Dropped ESP", "Dropped Weapon Chams") then
					newchild:WaitForChild("Slot1", 1)
					local children = newchild:GetChildren()

					for i = 1, #children do
						local curvalue = children[i]

						if not curvalue:IsA("Model") and curvalue.Name ~= "Humanoid" and curvalue.ClassName == "Part"
						then
							curvalue.Color = menu:GetVal("Visuals", "Dropped ESP", "Dropped Weapon Chams", COLOR, true)
							local vertexcolor = Vector3.new(curvalue.Color.R, curvalue.Color.G, curvalue.Color.B)
							local mesh = curvalue:FindFirstChild("Mesh")

							if mesh then
								mesh.VertexColor = vertexcolor
							end
							local texture = curvalue:FindFirstChild("Texture")
							if texture then
								texture:Destroy()
							end
						end
					end
				end
			end)

			local chat_game = LOCAL_PLAYER.PlayerGui.ChatGame
			local chat_box = chat_game:FindFirstChild(TEXTBOX)
			local oldpos = nil

			local function pfkeycheck(actionName, inputState, inputObject)
				if INPUT_SERVICE:GetFocusedTextBox() then
					return Enum.ContextActionResult.Sink
				end
				if INPUT_SERVICE:GetFocusedTextBox() or menu.textboxopen then
					return Enum.ContextActionResult.Sink
				end
				if actionName == "BB PF check" then
					if inputState == Enum.UserInputState.Begin then
						
						------------------------------------------
						------------"TOGGLES AND SHIT"------------
						------------------------------------------

						-- if menu:GetVal("Misc", "Exploits", "Fake Position") and client.char.alive and inputObject.KeyCode == menu:GetVal("Misc", "Exploits", "Fake Position", KEYBIND) then
						-- 	keybindtoggles.superaa = not keybindtoggles.superaa
						-- 	if keybindtoggles.superaa then
						-- 		client.char.rootpart.CustomPhysicalProperties = PhysicalProperties.new(1000, 1000, 0, 1000, 1000)
						-- 		CreateNotification("Fake Position has been enabled!")
						-- 		client.superaastart = client.char.head.CFrame
						-- 	else
						-- 		client.char.rootpart.CustomPhysicalProperties = nil
						-- 		client.char.rootpart.CFrame = client.superaastart
						-- 		client.superaastart = nil
						-- 	end
						-- 	return Enum.ContextActionResult.Sink
						-- end
						-- if menu:GetVal("Rage", "Extra", "Teleport Up") and inputObject.KeyCode == menu:GetVal("Rage", "Extra", "Teleport Up", KEYBIND) and client.char.alive then
						-- 	setfpscap(8)
						-- 	wait()
						-- 	client.char.rootpart.Position += Vector3.new(0, 38, 0) -- frame tp cheat tp up 38 studs wtf'
						-- 	setfpscap(maxfps or 144)
						-- 	wait()
						-- 	return Enum.ContextActionResult.Sink
						-- end
						-- if menu:GetVal("Misc", "Exploits", "Noclip") and inputObject.KeyCode == menu:GetVal("Misc", "Exploits", "Noclip", KEYBIND) and client.char.alive then
						-- 	local ray = Ray.new(client.char.head.Position, Vector3.new(0, -90, 0) * 20)

						-- 	local hit, hitpos = workspace:FindPartOnRayWithWhitelist(ray, {workspace.Map})

						-- 	if hit ~= nil and (not hit.CanCollide) or hit.Name == "Window" then
						-- 		CreateNotification("Attempting to enable noclip... (you may die)")
						-- 		keybindtoggles.fakebody = not keybindtoggles.fakebody
						-- 		client.fakeoffset = 18
						-- 	else
						-- 		CreateNotification("Unable to noclip. Do this as soon as you spawn or over glass. (be as close to ground as possible for best results)")
						-- 	end
						-- 	return Enum.ContextActionResult.Sink
						-- end
						if shitting_my_pants == false then
							if menu:GetVal("Misc", "Exploits", "Vertical Floor Clip") and inputObject.KeyCode == menu:GetVal("Misc", "Exploits", "Vertical Floor Clip", KEYBIND) and client.char.alive
							then
								local sign = not menu:modkeydown("alt", "left")
								local forward = menu:modkeydown("shift", "left")
								local ray = Ray.new(
									client.cam.cframe.Position,
									forward and Camera.CFrame.LookVector * 20 or Vector3.new(0, sign and -90 or 90, 0) * 20
								)

								local hit, hitpos = workspace:FindPartOnRayWithWhitelist(ray, { workspace.Map })

								if hit ~= nil and (hit.CanCollide == false or hit.Name == "Window") then
									if forward then
										client.char.rootpart.Position += Camera.CFrame.LookVector * 18
										CreateNotification("Clipped forward!")
									else
										client.char.rootpart.Position += Vector3.new(0, sign and -18 or 18, 0)
										CreateNotification("Clipped " .. (sign and "down" or "up") .. "!")
									end
								else
									CreateNotification(
										"Hit " .. (hit and (hit.Name .. tostring(hit.Material)) or "nothing") .. "."
									)
									CreateNotification("Unable to " .. (forward and "forward" or "floor") .. " clip!")
								end
								return Enum.ContextActionResult.Sink
							end
							local key = menu:GetVal("Misc", "Exploits", "Teleport", KEYBIND)
							if key == inputObject.KeyCode then
								if not menu:GetVal("Misc", "Exploits", "Bypass Speed Checks") then
									misc:Teleport()
									return Enum.ContextActionResult.Sink
								end
							end
						end

						if menu:GetVal("Misc", "Exploits", "Rapid Kill") and inputObject.KeyCode == menu:GetVal("Misc", "Exploits", "Rapid Kill", KEYBIND)
						then
							misc:RapidKill()
							return Enum.ContextActionResult.Sink
						end
						
						-- if menu:GetVal("Misc", "Exploits", "Invisibility") and inputObject.KeyCode == menu:GetVal("Misc", "Exploits", "Invisibility", KEYBIND)
						-- then
						-- 	local thing1, thing2 = misc:Invisibility()
						-- 	return Enum.ContextActionResult.Sink
						-- end
					end
					-----------------------------------------
					------------"HELD KEY ACTION"------------
					-----------------------------------------
					local keyflag = inputState == Enum.UserInputState.Begin
					
					if shitting_my_pants == false then

						--[[ if menu:GetVal("Misc", "Exploits", "Super Invisibility") and inputObject.KeyCode == menu:GetVal("Misc", "Exploits", "Super Invisibility", KEYBIND) then
					CreateNotification("Attempting to make you invisible, may need multiple attempts to fully work.")
					for i = 1, 50 do
						local num = i % 2 == 0 and 2 ^ 127 + 1 or -(2 ^ 127 + 1)
						send(nil, "repupdate", client.cam.cframe.p, Vector3.new(num, num, num))
					end
					return Enum.ContextActionResult.Sink
				end]]
						-- idk if this will even work anymore after the replication fixes
					end

					return Enum.ContextActionResult.Pass -- this will let any other keyboard action proceed
				end
			end

			game:service("ContextActionService"):BindAction("BB PF check", pfkeycheck, false, Enum.UserInputType.Keyboard)

			--[[ menu.connections.keycheck = INPUT_SERVICE.InputBegan:Connect(function(key)
				if chat_box.Active then return end
			end) ]]
			menu.connections.renderstepped_pf = game.RunService.RenderStepped:Connect(function(dt)
				if menu.lastActive ~= menu.windowactive then
					setfpscap((menu.windowactive or menu:GetVal("Misc", "Exploits", "Crash Server")) and (getgenv().maxfps or 144) or 15)
				end
				if menu:GetVal("Misc", "Exploits", "Crash Server") then
					for i = 1, menu:GetVal("Misc", "Exploits", "Crash Intensity") ^ 2 do
						-- client.net:send("getrounddata")
						-- client.net:send("changeclass", "Assault")
						-- client.net:send("changeclass", "Support")
						-- client.net:send("changeclass", "Recon")
						-- local other = i % 2 == 0 and "FLASHLIGHT" or ""
						-- local under = math.random() > 0.5 and "FLASHLIGHT" or ""
						-- client.net:send("changeclass", "Scout")
						-- client.net:send("changewep", "Primary", "COLT LMG")
						-- client.net:send("changecamo","Primary","COLT LMG","Slot2","",{ TextureId = "", StudsPerTileU = 1, StudsPerTileV=1, OffsetStudsV=0, Transparency=0, OffsetStudsU=0 },{ DefaultColor=true, Material="SmoothPlastic", BrickColor="Black", Reflectance=0 })
						-- client.net:send("changewep", "Primary", "MP5K")
						client.net:send("changeatt", "Primary", "MP5K", { Underbarrel = nil, Other = nil, Ammo = nil, Barrel = nil, Optics = nil })
						client.net:send("changeatt", "Primary", "MP5K", { Underbarrel = "",  Other = "",  Ammo = "",  Barrel = "",  Optics = ""  })
					end
					-- client.net:send("getunlockstats")
				end
				for index, time in next, ragebot.predictedDamageDealtRemovals do
					if time and (tick() > time) then
						ragebot.predictedDamageDealt[index] = 0
						if not ragebot.predictedMisses[index] then
							ragebot.predictedMisses[index] = 0
						end
						if not ragebot.predictedShotAt[index] then
							ragebot.predictedShotAt[index] = 0
						end
						ragebot.predictedMisses[index] += ragebot.predictedShotAt[index]
						ragebot.predictedShotAt[index] = 0
						time = nil
					end
				end

				MouseUnlockHook()
				-- debug.profilebegin("Main BB Loop")
				-- debug.profilebegin("Noclip Cheat check")
				if client.char.alive and menu:GetVal("Misc", "Exploits", "Rapid Kill") and menu:GetVal("Misc", "Exploits", "Auto Rapid Kill")

				then
					if misc:RapidKill() then
						client.net:send("forcereset")
					end
				else
					if menu:GetVal("Misc", "Extra", "Auto Respawn") then
						client.menu:deploy() -- this is uber ass
					end
				end
				if menu:GetVal("Rage", "Fake Lag", "Enabled") and menu:GetVal("Rage", "Fake Lag", "Manual Choke") then
					if menu:GetKey("Rage", "Fake Lag", "Manual Choke") then
						NETWORK:SetOutgoingKBPSLimit(menu:GetVal("Rage", "Fake Lag", "Fake Lag Amount"))
						ragebot.choking = true
					else
						ragebot.choking = false
						NETWORK:SetOutgoingKBPSLimit(0)
					end
				end
				--debug.profileend("Noclip Cheat check")

				--debug.profilebegin("BB Rendering")
				do --rendering
					renderVisuals(dt)
					if menu.open then
						setconstant(
							client.cam.step,
							11,
							menu:GetVal("Visuals", "Camera Visuals", "No Camera Bob") and 0 or 0.5
						)
					end
				end
				--debug.profileend("BB Rendering")
				--debug.profilebegin("BB Legitbot")
				do --legitbot
					legitbot:TriggerBot()
					legitbot:MainLoop()
				end
				--debug.profileend("BB Legitbot")
				--debug.profilebegin("BB Misc.")
				do --misc
					misc:MainLoop()
					--debug.profilebegin("BB Ragebot KnifeBot")
					ragebot:KnifeBotMain()
					--debug.profileend("BB Ragebot KnifeBot")
				end
				--debug.profileend("BB Misc.")
				if not menu:GetVal("Rage", "Settings", "Aimbot Performance Mode") then
					--debug.profilebegin("BB Ragebot (Non Performance)")
					do --ragebot
						ragebot:MainLoop()
					end
					--debug.profileend("BB Ragebot (Non Performance)")
				else
					ragebot.flip = not ragebot.flip
					if ragebot.flip then
						ragebot:MainLoop()
					end
				end

				if menu.spectating and not client.cam:isspectating() then
					if client.menu.isdeployed() then
						client.cam:setfirstpersoncam()
					elseif client.cam.type ~= "menu" then
						local lobby = workspace:FindFirstChild("MenuLobby")
						if lobby then
							client.cam:setmenucam(lobby)
						else
							--client.menu:loadmenu()
						end
					end
					menu.spectating = false
				end

				--debug.profileend("Main BB Loop")
			end)

			client.nextchamsupdate = tick()

			menu.connections.heartbeat_pf = game.RunService.Heartbeat:Connect(function()
				local curTick = tick()
				for index, nade in pairs(menu.activenades) do
					local nade_percent = (curTick - nade.start) / (nade.blowuptick - nade.start)
					if nade_percent >= 1 then
						if menu.activenades[index] == nade then
							table.remove(menu.activenades, index)
						end
					end
				end

				if client.nextchamsupdate and curTick > client.nextchamsupdate then
					client.nextchamsupdate = curTick + 0.8
					CreateThread(renderChams)
					local enemyesp = menu.options["Visuals"]["Enemy ESP"]["Enabled"][1]

					for player, nametagupdater in pairs(client.nametagupdaters) do
						if not client.nametagupdaters_cache[player] then
							if player.Team ~= LOCAL_PLAYER.Team then
								client.nametagupdaters_cache[player] = nametagupdater
							end
						else
							if enemyesp then
								if client.nametagupdaters[player] == client.nametagupdaters_cache[player] then
									client.nametagupdaters[player] = function(...)
									end
									client.playernametags[player].Visible = false
								end
							else
								if client.nametagupdaters[player] ~= client.nametagupdaters_cache[player] then
									client.nametagupdaters[player] = client.nametagupdaters_cache[player]
									client.playernametags[player].Visible = true
								end
							end
						end
					end
				end

				if menu.open then
					bulletcheckresolution = menu:GetVal("Rage", "Aimbot", "Autowall FPS (Standard)") / 1000
				end

				--debug.profilebegin("BB No Gun Bob or Sway")

				if client.char.alive then
					for id, gun in next, client.loadedguns do
						if not gun.fucku then
							local upvs = getupvalues(gun.step)
							local hopefullyfireroundupvs = getupvalues(upvs[#upvs]) -- tell json fuck u when this breaks next major pf update (war bonds) if not hes FUCKING GENIUS... 🧠🧠🧠🧠🧠
							for i = 1, #upvs do
								local curv = upvs[i]
								if type(curv) == "function" and getinfo(curv).name:match("bob") then
									gun.fucku = true
									setupvalue(client.loadedguns[id].step, i, function(...)
										return (
													menu and menu:GetVal("Visuals", "Camera Visuals", "No Gun Bob or Sway")
												) and CFrame.new() or curv(...)
									end)
								end
							end

							for j = 1, #hopefullyfireroundupvs do
								local curupvalue = hopefullyfireroundupvs[j]
								if type(curupvalue) == "table" and rawget(curupvalue, "setpv") then
									local lol = {}
									local mt = getrawmetatable(curupvalue)
									local newindex = mt.__newindex
									local stuff = getupvalues(newindex)
									if type(stuff[6]) == "userdata" then
										setrawmetatable(lol, {
											__newindex = function(t, p, v)
												if menu then
													if p == "a" and menu:GetVal("Misc", "Weapon Modifications", "Enabled")
													then -- this might also break the recoil since idk if they might change this back to like p or v or whatever the fuck idk dick sukkin god
														local recoil_scale = menu:GetVal(
															"Misc",
															"Weapon Modifications",
															"Recoil Scale"
														) / 100
														return newindex(t, p, v * recoil_scale)
													else
														return newindex(t, p, v)
													end
												else
													setrawmetatable(lol, mt)
													return newindex(t, p, v)
												end
											end,
										})
										setupvalue(upvs[#upvs], j, lol)
									end
								end
							end
						end
					end

					if client.logic.currentgun.knife and not client.logic.currentgun.fucku then
						local upvs = getupvalues(client.logic.currentgun.step)
						for i = 1, #upvs do
							local curv = upvs[i]
							if type(curv) == "function" and getinfo(curv).name:match("bob") then
								client.logic.currentgun.fucku = true
								setupvalue(client.logic.currentgun.step, i, function(...)
									return (menu and menu:GetVal("Visuals", "Camera Visuals", "No Gun Bob or Sway")) and CFrame.new() or curv(...)
								end)
							end
						end
					end
				end

				--debug.profileend()

				if menu:GetVal("Visuals", "Local", "Third Person") and menu:GetKey("Visuals", "Local", "Third Person") and client.char.alive
				then -- do third person model
					if client.char.alive then
						--debug.profilebegin("Third Person")
						if not client.fakecharacter then
							client.fakecharacter = true
							local localchar = LOCAL_PLAYER.Character:Clone()

							for k, v in next, localchar:GetChildren() do
								if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
									v.Transparency = 0
								end
							end

							localchar.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

							localchar.Parent = workspace["Ignore"]

							client.fakerootpart = localchar.HumanoidRootPart
							localchar.HumanoidRootPart.Anchored = true

							local torso = localchar.Torso
							client.fakeupdater.updatecharacter(localchar)

							client.fakeupdater.setstance(client.char.movementmode)

							local guntoequip = client.logic.currentgun.type == "KNIFE" and client.loadedguns[1].name or client.logic.currentgun.name -- POOP
							client.fakeupdater.equip(
								require(game:service("ReplicatedStorage").GunModules[guntoequip]),
								game:service("ReplicatedStorage").ExternalModels[guntoequip]:Clone()
							)
							client.fake3pchar = localchar
							if LOCAL_PLAYER.Character and LOCAL_PLAYER.Character.Torso and LOCAL_PLAYER.Character.Torso:FindFirstChild("Pant")
							then
								LOCAL_PLAYER.Character.Torso.Pant:Destroy()
							end
						else
							if LOCAL_PLAYER.Character and LOCAL_PLAYER.Character.Torso and LOCAL_PLAYER.Character.Torso:FindFirstChild("Pant") then
								LOCAL_PLAYER.Character.Torso.Pant:Destroy()
							end
							if not menu:GetVal("Rage", "Fake Lag", "Manual Choke") and not menu:GetKey("Rage", "Fake Lag", "Manual Choke") and not ragebot.choking then
								local fakeupdater = client.fakeupdater
								fakeupdater.step(3, false)

								local lchams = menu:GetVal("Visuals", "Local", "Local Player Chams")
								if lchams then
									local lchamscolor = menu:GetVal("Visuals", "Local", "Local Player Chams", COLOR, true)
									local lchamstransparency = menu:GetVal("Visuals", "Local", "Local Player Chams", COLOR)[4] / 255

									local lchamsmat = mats[menu:GetVal("Visuals", "Local", "Local Player Material")]

									local curchildren = client.fake3pchar:GetChildren()

									for i = 1, #curchildren do
										local curvalue = curchildren[i]
										if curvalue:IsA("BasePart") and curvalue.Name ~= "HumanoidRootPart" then
											curvalue.Material = Enum.Material[lchamsmat]
											curvalue.Color = lchamscolor
										end
									end
								end

								if menu:GetVal("Rage", "Anti Aim", "Enabled") then
									-- IM STUIPD........
									fakeupdater.setlookangles(ragebot.angles or Vector3.new())
									fakeupdater.setstance(ragebot.stance)
									fakeupdater.setsprint(ragebot.sprint)
								else
									local silentangles = ragebot.silentVector and Vector3.new(CFrame.new(Vector3.new(), ragebot.silentVector):ToOrientation()) or nil
									fakeupdater.setlookangles(silentangles or client.cam.angles) -- TODO make this face silent aim vector at some point lol
									fakeupdater.setstance(client.char.movementmode)
									fakeupdater.setsprint(client.char:sprinting())
								end
								if client.logic.currentgun then
									if client.logic.currentgun.type ~= "KNIFE" then
										local bool = client.logic.currentgun:isaiming()
										local transparency = 1 + menu:GetVal("Visuals", "Local", "Local Player Chams", COLOR)[4] / -255
										fakeupdater.setaim(bool)
										for k, v in next, client.fake3pchar:GetChildren() do -- this is probably going to cause a 1 fps drop or some shit lmao
											if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
												v.Transparency = bool and map(transparency, 0, 1, 0.5, 1) or transparency
											end
											if v:IsA("Model") then
												for k, v in next, v:GetChildren() do
													v.Transparency = bool and map(transparency, 0, 1, 0.5, 1) or transparency
												end
											end
										end
									end
								end

								-- 3 am already wtf 🌃

								if client.char.rootpart then
									client.fakerootpart.CFrame = client.char.rootpart.CFrame
									local rootpartpos = client.char.rootpart.Position
									local fakeupdaterupvals = debug.getupvalues(client.fakeupdater.step)
									fakeupdaterupvals[4].p = rootpartpos
									fakeupdaterupvals[4].t = rootpartpos
									fakeupdaterupvals[4].v = Vector3.new()
								end
							end
						end
						--debug.profileend("Third Person")
					end
				else
					if client.fakecharacter then
						local hiddenpos = Vector3.new(-1000,-1000,-1000)
						local fakeupdaterupvals = debug.getupvalues(client.fakeupdater.step)
						fakeupdaterupvals[4].p = hiddenpos
						fakeupdaterupvals[4].t = hiddenpos
						fakeupdaterupvals[4].v = Vector3.new()
					end
					if client.fakecharacter then
						client.fakecharacter = false
						
						--client.replication.removecharacterhash(client.fakeplayer)
						for k, v in next, client.fake3pchar:GetChildren() do
							if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
								v.Transparency = 1
							end
							if v:IsA("Model") then
								for k, v in next, v:GetChildren() do
									v.Transparency = 1
								end
							end
							if v:FindFirstChild("Face") then
								v.Face:Destroy()
							end
							if v:FindFirstChild("Mesh") then
								v.Mesh:Destroy()
							end
						end
					end
				end
			end)

			menu.Initialize({
				{ --ANCHOR stuffs
					name = "Legit",
					content = {
						{
							name = "Aim Assist",
							autopos = "left",
							content = {
								{
									type = TOGGLE,
									name = "Enabled",
									value = true,
								},
								{
									type = SLIDER,
									name = "Aimbot FOV",
									value = 20,
									minvalue = 0,
									maxvalue = 180,
									stradd = "°",
								},
								{
									type = SLIDER,
									name = "Smoothing",
									value = 20,
									minvalue = 0,
									maxvalue = 100,
									stradd = "%",
								},
								{
									type = DROPBOX,
									name = "Smoothing Type",
									value = 2,
									values = { "Exponential", "Linear" },
								},
								{
									type = SLIDER,
									name = "Randomization",
									value = 5,
									minvalue = 0,
									maxvalue = 20,
									custom = { [0] = "Off" },
								},
								{
									type = SLIDER,
									name = "Deadzone FOV",
									value = 1,
									minvalue = 0,
									maxvalue = 50,
									stradd = "°",
									decimal = 0.1,
									custom = { [0] = "Off" },
								},
								{
									type = DROPBOX,
									name = "Aimbot Key",
									value = 1,
									values = { "Mouse 1", "Mouse 2", "Always", "Dynamic Always" },
								},
								{
									type = DROPBOX,
									name = "Hitscan Priority",
									value = 1,
									values = { "Head", "Body", "Closest" },
								},
								{
									type = COMBOBOX,
									name = "Hitscan Points",
									values = { { "Head", true }, { "Body", true }, { "Arms", false }, { "Legs", false } },
								},
								{
									type = TOGGLE,
									name = "Adjust for Bullet Drop",
									value = false,
								},
								{
									type = TOGGLE,
									name = "Target Prediction",
									value = false,
								},
								{
									type = SLIDER,
									name = "Enlarge Enemy Hitboxes",
									value = 0,
									minvalue = 0,
									maxvalue = 100,
									stradd = "%",
								},
							},
						},
						{
							name = "Trigger Bot",
							autopos = "right",
							content = {
								{
									type = TOGGLE,
									name = "Enabled",
									value = false,
									extra = {
										type = KEYBIND,
										key = Enum.KeyCode.M,
									},
								},
								{
									type = COMBOBOX,
									name = "Trigger Bot Hitboxes",
									values = { { "Head", true }, { "Body", true }, { "Arms", false }, { "Legs", false } },
								},
								{
									type = TOGGLE,
									name = "Trigger When Aiming",
									value = false,
								},
								{
									type = SLIDER,
									name = "Aim Percentage",
									minvalue = 0,
									maxvalue = 100,
									value = 90,
									stradd = "%",
								},
								--[[
						{
							type = TOGGLE,
							name = "Magnet Triggerbot",
							value = false
						},
						{
							type = SLIDER,
							name = "Magnet FOV",
							value = 80,
							minvalue = 0,
							maxvalue = 180,
							stradd = "°"
						},
						{
							type = SLIDER,
							name = "Magnet Smoothing Factor",
							value = 20,
							minvalue = 0,
							maxvalue = 50,
							stradd = "%"
						},
						{
							type = DROPBOX,
							name = "Magnet Priority",
							value = 1,
							values = {"Head", "Body"}
						},]]
							},
						},
						{
							name = "Bullet Redirection",
							autopos = "right",
							autofill = true,
							content = {
								{
									type = TOGGLE,
									name = "Silent Aim",
									value = false,
								},
								{
									type = SLIDER,
									name = "Silent Aim FOV",
									value = 5,
									minvalue = 0.1,
									maxvalue = 180,
									stradd = "°",
									decimal = 0.1,
								},
								{
									type = SLIDER,
									name = "Hit Chance",
									value = 30,
									minvalue = 0,
									maxvalue = 100,
									stradd = "%",
								},
								{
									type = SLIDER,
									name = "Accuracy",
									value = 90,
									minvalue = 0,
									maxvalue = 100,
									stradd = "%",
								},
								{
									type = DROPBOX,
									name = "Hitscan Priority",
									value = 1,
									values = { "Head", "Body", "Closest" },
								},
								{
									type = COMBOBOX,
									name = "Hitscan Points",
									values = { { "Head", true }, { "Body", true }, { "Arms", false }, { "Legs", false } },
								},
							},
						},
						{
							name = "Recoil Control",
							autopos = "left",
							autofill = true,
							content = {
								{
									type = TOGGLE,
									name = "Weapon RCS",
									value = false,
								},
								{
									type = SLIDER,
									name = "Recoil Control X",
									value = 10,
									minvalue = 0,
									maxvalue = 100,
									stradd = "%",
								},
								{
									type = SLIDER,
									name = "Recoil Control Y",
									value = 10,
									minvalue = 0,
									maxvalue = 100,
									stradd = "%",
								},
							},
						},
					},
				},
				{
					name = "Rage",
					content = {
						{
							name = "Aimbot",
							autopos = "left",
							content = {
								{
									type = TOGGLE,
									name = "Enabled",
									value = false,
									extra = {
										type = KEYBIND,
										toggletype = 4,
									},
									unsafe = true,
								},
								{
									type = TOGGLE,
									name = "Silent Aim",
									value = false,
									tooltip = "Stops the camera from rotating toward targetted players.",
								},
								{
									type = TOGGLE,
									name = "Rotate Viewmodel",
									value = false,
									tooltip = "Rotates weapon viewmodel toward the targetted player."
								},
								{
									type = SLIDER,
									name = "Aimbot FOV",
									value = 180,
									minvalue = 0,
									maxvalue = 181,
									stradd = "°",
									custom = { [181] = "Ignored" },
								},
								{
									type = DROPBOX,
									name = "Auto Wall",
									value = 1,
									values = { "Off", "Standard", "Legacy" },
								},
								{
									type = SLIDER,
									name = "Autowall FPS (Standard)",
									value = 30,
									minvalue = 10,
									maxvalue = 30,
									stradd = "fps",
								},
								{
									type = TOGGLE,
									name = "Auto Shoot",
									value = false,
									tooltip = "Automatically shoots players when a target is found."
								},
								{
									type = TOGGLE,
									name = "Double Tap",
									value = false,
									tooltip = "Shoots twice when target is found when Auto Shoot is enabled."
								},
								{
									type = DROPBOX,
									name = "Hitscan Priority",
									value = 1,
									values = { "Head", "Body" },
								},
							},
						},
						{
							name = "Hack vs. Hack",
							autopos = "right",
							content = {
								--[[{
									type = TOGGLE,
									name = "Extend Penetration",
									value = false
								},]]
								-- {
								-- 	type = SLIDER,
								-- 	name = "Extra Penetration",
								-- 	value = 11,
								-- 	minvalue = 1,
								-- 	maxvalue = 20,
								-- 	stradd = " studs",
								-- 	tooltip = "does nothing",
								-- }, -- fuck u json
								{
									type = TOGGLE,
									name = "Autowall Hitscan",
									value = false,
									unsafe = true,
									tooltip = "While using Auto Wall, this will hitscan multiple points\nto increase penetration and help for peeking.",
								},
								{
									type = COMBOBOX,
									name = "Hitscan Points",
									values = {
										{ "Up", true },
										{ "Down", true },
										{ "Left", false },
										{ "Right", false },
										{ "Forward", true },
										{ "Backward", true },
										{ "Origin", true },
										{ "Towards", true },
									},
								},
								{
									type = TOGGLE,
									name = "Hitbox Shifting",
									value = false,
									tooltip = "Increases possible penetration with Autowall. The higher\nthe Hitbox Shift Distance the more likely it is to miss shots.\nWhen it misses it will try disable this.",
								},
								{
									type = SLIDER,
									name = "Hitbox Shift Distance",
									value = 16,
									minvalue = 1,
									maxvalue = 30,
									stradd = " studs",
								},
								{
									type = TOGGLE,
									name = "Force Player Stances",
									value = false,
									tooltip = "Changes the stance of other players to the selected Stance Choice.",
								},
								{
									type = DROPBOX,
									name = "Stance Choice",
									value = 1,
									values = { "Stand", "Crouch", "Prone" },
								},
								{
									type = TOGGLE, 
									name = "Backtracking",
									value = false,
									tooltip = "Attempts to abuse lag compensation and shoot players where they were in the past.\nUsing Visuals->Enemy ESP->Show Backtracked Position will help illustrate this."
								},
								{
									type = SLIDER,
									name = "Backtracking Time",
									value = 4000,
									minvalue = 0,
									maxvalue = 5000,
									stradd = " ms",
								},
								{
									type = TOGGLE,
									name = "Freestanding",
									value = false,
									extra = {
										type = KEYBIND,
									},
								},
							},
						},
						{
							name = { "Extra", "Settings" },
							autopos = "left",
							autofill = true,
							[1] = {
								content = {
									{
										type = TOGGLE,
										name = "Knife Bot",
										value = false,
										extra = {
											type = KEYBIND,
										},
										unsafe = true,
									},
									{
										type = DROPBOX,
										name = "Knife Bot Type",
										value = 2,
										values = { "Assist", "Multi Aura", "Flight Aura" },
									},
									{
										type = TOGGLE,
										name = "Auto Peek",
										value = false,
										extra = {
											type = KEYBIND,
											toggletype = 1,
										},
										tooltip = "Hitscans from in front of your camera,\nif a target is found it will move you towards the point automatically",
									},
								},
							},
							[2] = {
								content = {
									{
										type = TOGGLE,
										name = "Aimbot Performance Mode",
										value = true,
										tooltip = "Lowers polling rate for targetting in Rage Aimbot.",
									},
									{
										type = TOGGLE,
										name = "Resolve Fake Positions",
										value = true,
										tooltip = "Rage aimbot attempts to resolve Crimwalk on other players.\nDisable if you are having issues with resolver.",
									},
									{
										type = TOGGLE,
										name = "Aimbot Damage Prediction",
										value = true,
										tooltip = "Predicts damage done to enemies as to prevent wasting ammo and time on certain players.\nHelps for users, and against players with high latency.",
									},
									{
										type = SLIDER,
										name = "Damage Prediction Limit",
										value = 100,
										minvalue = 0,
										maxvalue = 300,
										stradd = "hp",
									},
									{
										type = SLIDER,
										name = "Damage Prediction Time",
										value = 200,
										minvalue = 100,
										maxvalue = 500,
										stradd = "%",
									},
									{
										type = SLIDER,
										name = "Max Hitscan Points",
										value = 30,
										minvalue = 0,
										maxvalue = 300,
										stradd = " points",
									},
								},
							},
						},
						{
							name = { "Anti Aim", "Fake Lag" },
							autopos = "right",
							autofill = true,
							[1] = {
								content = {
									{
										type = TOGGLE,
										name = "Enabled",
										value = false,
										tooltip = "When this is enabled, your server-side yaw, pitch and stance are set to the values in this tab.",
									},
									{
										type = DROPBOX,
										name = "Pitch",
										value = 4,
										values = {
											"Off",
											"Up",
											"Zero",
											"Down",
											"Upside Down",
											"Roll Forward",
											"Roll Backward",
											"Random",
											"Bob",
											"Glitch",
										},
									},
									{
										type = DROPBOX,
										name = "Yaw",
										value = 2,
										values = { "Forward", "Backward", "Spin", "Random", "Glitch Spin", "Stutter Spin" },
									},
									{
										type = SLIDER,
										name = "Spin Rate",
										value = 10,
										minvalue = -100,
										maxvalue = 100,
										stradd = "°/s",
									},
									{
										type = DROPBOX,
										name = "Force Stance",
										value = 4,
										values = { "Off", "Stand", "Crouch", "Prone" },
									},
									{
										type = TOGGLE,
										name = "Hide in Floor",
										value = true,
										tooltip = "Shifts your body slightly under the ground\nso as to hide it when Force Stance is set to Prone.",
									},
									{
										type = TOGGLE,
										name = "Lower Arms",
										value = false,
										tooltip = "Lowers your arms on the server.",
									},
									{
										type = TOGGLE,
										name = "Tilt Neck",
										value = false,
										tooltip = "Forces the replicated aiming state so that it appears as though your head is tilted.",
									},
								},
							},
							[2] = {
								content = {
									{
										type = TOGGLE,
										name = "Enabled",
										value = false,
									},
									{
										type = SLIDER,
										name = "Fake Lag Amount",
										value = 1,
										minvalue = 1,
										maxvalue = 1000,
										stradd = " kbps",
									},
									{
										type = SLIDER,
										name = "Fake Lag Distance",
										value = 1,
										minvalue = 1,
										maxvalue = 40,
										stradd = " studs",
									},
									{
										type = TOGGLE,
										name = "Manual Choke",
										extra = {
											type = KEYBIND,
										},
									},
									{
										type = TOGGLE,
										name = "Release Packets on Shoot",
										value = false,
									},
								},
							},
						},
					},
				},
				{
					name = "Visuals",
					content = {
						{
							name = { "Enemy ESP", "Team ESP", "Local" },
							autopos = "left",
							size = 316,
							[1] = {
								content = {
									{
										type = TOGGLE,
										name = "Enabled",
										value = true,
										tooltip = "Enables 2D rendering, disabling this could improve performance.\nDoes not affect Chams."
									},
									{
										type = TOGGLE,
										name = "Name",
										value = true,
										extra = {
											type = COLORPICKER,
											name = "Enemy Name",
											color = { 255, 255, 255, 200 },
										},
									},
									{
										type = TOGGLE,
										name = "Box",
										value = true,
										extra = {
											type = DOUBLE_COLORPICKER,
											name = { "Enemy Box Fill", "Enemy Box" },
											color = { { 255, 0, 0, 0 }, { 255, 0, 0, 150 } },
										},
									},
									{
										type = TOGGLE,
										name = "Health Bar",
										value = true,
										extra = {
											type = DOUBLE_COLORPICKER,
											name = { "Enemy Low Health", "Enemy Max Health" },
											color = { { 255, 0, 0 }, { 0, 255, 0 } },
										},
									},
									{
										type = TOGGLE,
										name = "Health Number",
										value = true,
										extra = {
											type = COLORPICKER,
											name = "Enemy Health Number",
											color = { 255, 255, 255, 255 },
										},
									},
									{
										type = TOGGLE,
										name = "Held Weapon",
										value = true,
										extra = {
											type = COLORPICKER,
											name = "Enemy Held Weapon",
											color = { 255, 255, 255, 200 },
										},
									},
									{
										type = TOGGLE,
										name = "Held Weapon Icon",
										value = false,
									},
									{
										type = COMBOBOX,
										name = "Flags",
										values = { { "Level", true }, { "Distance", true }, { "Resolved", false } },
									},
									{
										type = TOGGLE,
										name = "Chams",
										value = true,
										extra = {
											type = DOUBLE_COLORPICKER,
											name = { "Visible Enemy Chams", "Invisible Enemy Chams" },
											color = { { 255, 0, 0, 200 }, { 100, 0, 0, 100 } },
										},
									},
									{
										type = TOGGLE,
										name = "Skeleton",
										value = false,
										extra = {
											type = COLORPICKER,
											name = "Enemy skeleton",
											color = { 255, 255, 255, 120 },
										},
									},
									{
										type = TOGGLE,
										name = "Out of View",
										value = true,
										extra = {
											type = COLORPICKER,
											name = "Arrow Color",
											color = { 255, 255, 255, 255 },
										},
									},
									{
										type = SLIDER,
										name = "Arrow Distance",
										value = 50,
										minvalue = 10,
										maxvalue = 100,
										stradd = "%",
									},
									{
										type = TOGGLE,
										name = "Dynamic Arrow Size",
										value = true,
									},
									{
										type = TOGGLE,
										name = "Show Backtrack Position",
										extra = {
											type = COLORPICKER,
											name = "Backtracking Color",
											color = { 255, 255, 255, 255 },
										},
										value = false,
									},
								},
							},
							[2] = {
								content = {
									{
										type = TOGGLE,
										name = "Enabled",
										value = false,
										tooltip = "Enables 2D rendering, disabling this could improve performance.\nDoes not affect Chams."
									},
									{
										type = TOGGLE,
										name = "Name",
										value = false,
										extra = {
											type = COLORPICKER,
											name = "Team Name",
											color = { 255, 255, 255, 200 },
										},
									},
									{
										type = TOGGLE,
										name = "Box",
										value = true,
										extra = {
											type = DOUBLE_COLORPICKER,
											name = { "Enemy Box Fill", "Enemy Box" },
											color = { { 0, 255, 0, 0 }, { 0, 255, 0, 150 } },
										},
									},
									{
										type = TOGGLE,
										name = "Health Bar",
										value = false,
										extra = {
											type = DOUBLE_COLORPICKER,
											name = { "Team Low Health", "Team Max Health" },
											color = { { 255, 0, 0 }, { 0, 255, 0 } },
										},
									},
									{
										type = TOGGLE,
										name = "Health Number",
										value = false,
										extra = {
											type = COLORPICKER,
											name = "Team Health Number",
											color = { 255, 255, 255, 255 },
										},
									},
									{
										type = TOGGLE,
										name = "Held Weapon",
										value = false,
										extra = {
											type = COLORPICKER,
											name = "Team Held Weapon",
											color = { 255, 255, 255, 200 },
										},
									},
									{
										type = TOGGLE,
										name = "Held Weapon Icon",
										value = false,
									},
									{
										type = COMBOBOX,
										name = "Flags",
										values = { { "Level", false }, { "Distance", false } },
									},
									{
										type = TOGGLE,
										name = "Chams",
										value = false,
										extra = {
											type = DOUBLE_COLORPICKER,
											name = { "Visible Team Chams", "Invisible Team Chams" },
											color = { { 0, 255, 0, 200 }, { 0, 100, 0, 100 } },
										},
									},
									{
										type = TOGGLE,
										name = "Skeleton",
										value = false,
										extra = {
											type = COLORPICKER,
											name = "Team skeleton",
											color = { 255, 255, 255, 120 },
										},
									},
								},
							},
							[3] = {
								content = {
									{
										type = TOGGLE,
										name = "Arm Chams",
										value = false,
										extra = {
											type = DOUBLE_COLORPICKER,
											name = { "Sleeve Color", "Hand Color" },
											color = { { 106, 136, 213, 255 }, { 181, 179, 253, 255 } },
										},
									},
									{
										type = DROPBOX,
										name = "Arm Material",
										value = 1,
										values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
									},
									{
										type = TOGGLE,
										name = "Weapon Chams",
										value = false,
										extra = {
											type = DOUBLE_COLORPICKER,
											name = { "Weapon Color", "Laser Color" },
											color = { { 106, 136, 213, 255 }, { 181, 179, 253, 255 } },
										},
									},
									{
										type = DROPBOX,
										name = "Weapon Material",
										value = 1,
										values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
									},
									{
										type = TOGGLE,
										name = "Animate Ghost Material",
										value = false,
										tooltip = "Toggles whether or not the 'Ghost' material will be animated or not.",
									},
									{
										type = TOGGLE,
										name = "Remove Weapon Skin",
										value = false,
										tooltip = "If a loaded weapon has a skin, it will remove it.",
									},
									{
										type = TOGGLE,
										name = "Third Person",
										value = false,
										extra = {
											type = KEYBIND,
											key = nil,
											toggletype = 2,
										},
									},
									{
										type = SLIDER,
										name = "Third Person Distance",
										value = 60,
										minvalue = 1,
										maxvalue = 150,
									},
									{
										type = TOGGLE,
										name = "Local Player Chams",
										value = false,
										extra = {
											type = COLORPICKER,
											name = "Local Player Chams",
											color = { 106, 136, 213, 255 },
										},
										tooltip = "Changes the color and material of the local third person body when it is on.",
									},
									{
										type = DROPBOX,
										name = "Local Player Material",
										value = 1,
										values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
									},
								},
							},
						},
						{
							name = "ESP Settings",
							autopos = "left",
							autofill = true,
							content = {
								{
									type = SLIDER,
									name = "Max HP Visibility Cap",
									value = 90,
									minvalue = 50,
									maxvalue = 100,
									stradd = "hp",
								},
								{
									type = DROPBOX,
									name = "Text Case",
									value = 2,
									values = { "lowercase", "Normal", "UPPERCASE" },
								},
								{
									type = SLIDER,
									name = "Max Text Length",
									value = 0,
									minvalue = 0,
									maxvalue = 32,
									custom = { [0] = "Unlimited" },
								},
								{
									type = TOGGLE,
									name = "Highlight Aimbot Target",
									value = false,
									extra = {
										type = COLORPICKER,
										name = "Aimbot Target",
										color = { 255, 0, 0, 255 },
									},
								},
								{
									type = TOGGLE,
									name = "Highlight Friends",
									value = true,
									extra = {
										type = COLORPICKER,
										name = "Friended Players",
										color = { 0, 255, 255, 255 },
									},
								},
								{
									type = TOGGLE,
									name = "Highlight Priority",
									value = true,
									extra = {
										type = COLORPICKER,
										name = "Priority Players",
										color = { 255, 210, 0, 255 },
									},
								},
								-- {
								-- 	type = SLIDER,
								-- 	name = "Max Player Text",
								-- 	value = 0,
								-- 	minvalue = 0,
								-- 	maxvalue = 32,
								-- 	custom = {[0] = "None"},
								-- }
							},
						},
						{
							name = { "Camera Visuals", "Viewmodel" },
							autopos = "right",
							size = 228,
							[1] = {
								content = {
									{
										type = SLIDER,
										name = "Camera FOV",
										value = 85,
										minvalue = 60,
										maxvalue = 120,
										stradd = "°",
									},
									{
										type = TOGGLE,
										name = "No Camera Bob",
										value = false,
									},
									{
										type = TOGGLE,
										name = "No Scope Sway",
										value = false,
									},
									{
										type = TOGGLE,
										name = "Disable ADS FOV",
										value = false,
									},
									{
										type = TOGGLE,
										name = "No Scope Border",
										value = false,
									},
									{
										type = TOGGLE,
										name = "No Visual Suppression",
										value = false,
										tooltip = "Removes the suppression of enemies' bullets.",
									},
									{
										type = TOGGLE,
										name = "No Gun Bob or Sway",
										value = false,
										tooltip = "Removes the bob and sway of weapons when walking.\nThis does not remove the swing effect when moving the mouse.",
									},
									{
										type = TOGGLE,
										name = "Reduce Camera Recoil",
										value = false,
										tooltip = "Reduces camera recoil by X%. Does not affect visible weapon recoil or kick.",
									},
									{
										type = SLIDER,
										name = "Camera Recoil Reduction",
										value = 10,
										minvalue = 0,
										maxvalue = 100,
										stradd = "%",
									},
								},
							},
							[2] = {
								content = {
									{
										type = TOGGLE,
										name = "Enabled",
										value = false,
									},
									{
										type = SLIDER,
										name = "Offset X",
										value = 0,
										minvalue = -3,
										maxvalue = 3,
										decimal = 0.01,
										stradd = " studs",
									},
									{
										type = SLIDER,
										name = "Offset Y",
										value = 0,
										minvalue = -3,
										maxvalue = 3,
										decimal = 0.01,
										stradd = " studs",
									},
									{
										type = SLIDER,
										name = "Offset Z",
										value = 0,
										minvalue = -3,
										maxvalue = 3,
										decimal = 0.01,
										stradd = " studs",
									},
									{
										type = SLIDER,
										name = "Pitch",
										value = 0,
										minvalue = -360,
										maxvalue = 360,
										stradd = "°",
									},
									{
										type = SLIDER,
										name = "Yaw",
										value = 0,
										minvalue = -360,
										maxvalue = 360,
										stradd = "°",
									},
									{
										type = SLIDER,
										name = "Roll",
										value = 0,
										minvalue = -360,
										maxvalue = 360,
										stradd = "°",
									},
								},
							},
						},
						{
							name = { "World", "Misc", "Keybinds", "FOV" },

							autopos = "right",
							size = 144,
							[1] = {
								content = {
									{
										type = TOGGLE,
										name = "Ambience",
										value = false,
										extra = {
											type = DOUBLE_COLORPICKER,
											name = { "Inside Ambience", "Outside Ambience" },
											color = { { 117, 76, 236 }, { 117, 76, 236 } },
										},
										tooltip = "Changes the map's ambient colors to your defined colors.",
									},
									{
										type = TOGGLE,
										name = "Force Time",
										value = false,
										tooltip = "Forces the time to the time set by your below.",
									},
									{
										type = SLIDER,
										name = "Custom Time",
										value = 0,
										minvalue = 0,
										maxvalue = 24,
										decimal = 0.1,
									},
									{
										type = TOGGLE,
										name = "Custom Saturation",
										value = false,
										extra = {
											type = COLORPICKER,
											name = "Saturation Tint",
											color = { 255, 255, 255 },
										},
										tooltip = "Adds custom saturation the image of the game.",
									},
									{
										type = SLIDER,
										name = "Saturation Density",
										value = 0,
										minvalue = 0,
										maxvalue = 100,
										stradd = "%",
									},
								},
							},
							[2] = {
								content = {
									{
										type = TOGGLE,
										name = "Crosshair Color",
										value = false,
										extra = {
											type = DOUBLE_COLORPICKER,
											name = { "Inline", "Outline" },
											color = { { 127, 72, 163 }, { 25, 25, 25 } },
										},
									},
									{
										type = TOGGLE,
										name = "Laser Pointer",
										value = false,
										extra = {
											type = COLORPICKER,
											name = "Laser Pointer Color",
											color = { 255, 255, 255, 255 },
										},
									},
									{
										type = TOGGLE,
										name = "Ragdoll Chams",
										value = false,
										extra = {
											type = COLORPICKER,
											name = "Ragdoll Chams",
											color = { 106, 136, 213, 255 },
										},
									},
									{
										type = DROPBOX,
										name = "Ragdoll Material",
										value = 1,
										values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
									},
									{
										type = TOGGLE,
										name = "Bullet Tracers",
										value = false,
										extra = {
											type = COLORPICKER,
											name = "Bullet Tracers",
											color = { 201, 69, 54 },
										},
									},
								},
							},
							[3] = {
								content = {
									{
										type = TOGGLE,
										name = "Enabled",
										value = false,
										extra = {
											type = COLORPICKER,
											name = "Text Color",
											color = { 127, 72, 163, 255 },
										},
									},
									{
										type = TOGGLE,
										name = "Use List Sizes",
										value = false,
									},
									{
										type = TOGGLE,
										name = "Log Keybinds",
										value = false
									},
									{
										type = SLIDER,
										name = "Keybinds List X",
										value = 0,
										minvalue = 0,
										maxvalue = 100,
										stradd = "%",
									},
									{
										type = SLIDER,
										name = "Keybinds List Y",
										value = 50,
										minvalue = 0,
										maxvalue = 100,
										stradd = "%",
									},
								},
							},
							[4] = {
								content = {
									{
										type = TOGGLE,
										name = "Enabled",
										value = false,
									},
									{
										type = TOGGLE,
										name = "Aim Assist",
										value = true,
										extra = {
											type = COLORPICKER,
											name = "Aim Assist FOV",
											color = { 127, 72, 163, 255 },
										},
									},
									{
										type = TOGGLE,
										name = "Aim Assist Deadzone",
										value = true,
										extra = {
											type = COLORPICKER,
											name = "Deadzone FOV",
											color = { 50, 50, 50, 255 },
										},
									},
									{
										type = TOGGLE,
										name = "Bullet Redirection",
										value = false,
										extra = {
											type = COLORPICKER,
											name = "Bullet Redirection FOV",
											color = { 163, 72, 127, 255 },
										},
									},
									{
										type = TOGGLE,
										name = "Ragebot",
										value = false,
										extra = {
											type = COLORPICKER,
											name = "Ragebot FOV",
											color = { 255, 210, 0, 255 },
										},
									},
								},
							},
						},
						{
							name = "Dropped ESP",
							autopos = "right",
							autofill = true,
							content = {
								{
									type = TOGGLE,
									name = "Weapon Names",
									value = false,
									extra = {
										type = DOUBLE_COLORPICKER,
										name = { "Highlighted Weapons", "Weapon Names" },
										color = { { 255, 125, 255, 255 }, { 255, 255, 255, 255 } },
									},
									tooltip = "Displays dropped weapons as you get closer to them,\nHighlights the weapon you are holding in the second color.",
								},
								{
									type = TOGGLE,
									name = "Weapon Icons",
									value = false
								},
								{
									type = TOGGLE,
									name = "Weapon Ammo",
									value = false,
									extra = {
										type = COLORPICKER,
										name = "Weapon Ammo",
										color = { 61, 168, 235, 150 },
									},
								},
								{
									type = TOGGLE,
									name = "Dropped Weapon Chams",
									value = false,
									extra = {
										type = COLORPICKER,
										name = "Dropped Weapon Color",
										color = { 3, 252, 161, 150 },
									},
								},
								{
									type = TOGGLE,
									name = "Grenade Warning",
									value = true,
									extra = {
										type = COLORPICKER,
										name = "Slider Color",
										color = { 68, 92, 227 },
									},
									tooltip = "Displays where grenades that will deal\ndamage to you will land and the damage they will deal.",
								},
								{
									type = TOGGLE,
									name = "Grenade ESP",
									value = false,
									extra = {
										type = DOUBLE_COLORPICKER,
										name = { "Inner Color", "Outer Color" },
										color = { { 195, 163, 255 }, { 123, 69, 224 } },
									},
									tooltip = "Displays the full path of any grenade that will deal damage to you is thrown.",
								},
							},
						},
					},
				},
				{
					name = "Misc",
					content = {
						{
							name = { "Movement", "Tweaks" },
							autopos = "left",
							size = 300,
							[1] = {
								content = {
									{
										type = TOGGLE,
										name = "Fly",
										value = false,
										unsafe = true,
										tooltip = "Manipulates your velocity to make you fly.\nUse 60 speed or below to never get flagged.",
										extra = {
											type = KEYBIND,
											key = Enum.KeyCode.B,
											toggletype = 2,
										},
									},
									{
										type = SLIDER,
										name = "Fly Speed",
										value = 60,
										minvalue = 1,
										maxvalue = 400,
										stradd = " stud/s",
									},
									{
										type = TOGGLE,
										name = "Auto Jump",
										value = false,
										tooltip = "When you hold the spacebar, it will automatically jump repeatedly, ignoring jump delay.",
									},
									{
										type = TOGGLE,
										name = "Speed",
										value = false,
										unsafe = true,
										tooltip = "Manipulates your velocity to make you move faster, unlike fly it doesn't make you fly.\nUse 60 speed or below to never get flagged.",
										extra = {
											type = KEYBIND,
											toggletype = 4,
										},
									},
									{
										type = DROPBOX,
										name = "Speed Type",
										value = 1,
										values = { "Always", "In Air", "On Hop" },
									},
									{
										type = SLIDER,
										name = "Speed Factor",
										value = 40,
										minvalue = 1,
										maxvalue = 400,
										stradd = " stud/s",
									},
									{
										type = TOGGLE,
										name = "Avoid Collisions",
										value = false,
										tooltip = "Attempts to stops you from running into obstacles\nfor Speed and Circle Strafe.",
										extra = {
											type = KEYBIND,
											toggletype = 4,
										}
									},
									{
										type = SLIDER,
										name = "Avoid Collisions Scale",
										value = 100,
										minvalue = 0,
										maxvalue = 100,
										stradd = "%",
									},
									{
										type = TOGGLE,
										name = "Circle Strafe",
										value = false,
										extra = {
											type = KEYBIND,
										},
										tooltip = "When you hold this keybind, it will strafe in a perfect circle.\nSpeed of strafing is borrowed from Speed Factor.",
									},
								},
							},
							[2] = {
								content = {
									{
										type = TOGGLE,
										name = "Gravity Shift",
										value = false,
										tooltip = "Shifts movement gravity by X%. (Does not affect bullet acceleration.)",
									},
									{
										type = SLIDER,
										name = "Gravity Shift Percentage",
										value = -50,
										minvalue = -500,
										maxvalue = 500,
										stradd = "%",
									},
									{
										type = TOGGLE,
										name = "Jump Power",
										value = false,
										tooltip = "Shifts movement jump power by X%.",
									},
									{
										type = SLIDER,
										name = "Jump Power Percentage",
										value = 150,
										minvalue = 0,
										maxvalue = 1000,
										stradd = "%",
									},
									{
										type = TOGGLE,
										name = "Prevent Fall Damage",
										value = false,
									},
								},
							},
						},
						{
							name = "Weapon Modifications",
							autopos = "left",
							autofill = true,
							content = {
								{
									type = TOGGLE,
									name = "Enabled",
									value = false,
									tooltip = "Allows Bitch Bot to modify weapons.",
								},
								{
									type = SLIDER,
									name = "Fire Rate Scale",
									value = 150,
									minvalue = 50,
									maxvalue = 500,
									stradd = "%",
									tooltip = "Scales all weapons' firerate by X%.\n100% = Normal firerate",
								},
								{
									type = SLIDER,
									name = "Recoil Scale",
									value = 10,
									minvalue = 0,
									maxvalue = 100,
									stradd = "%",
									tooltip = "Scales all weapons' recoil by X%.\n0% = No recoil | 50% = Halved recoil",
								},
								{
									type = TOGGLE,
									name = "Remove Animations",
									value = true,
									tooltip = "Removes all animations from any gun.\nThis will also completely remove the equipping animations.",
								},
								{
									type = TOGGLE,
									name = "Instant Equip",
									value = true,
								},
								{
									type = TOGGLE,
									name = "Fully Automatic",
									value = true,
								},
								{
									type = TOGGLE,
									name = "Run and Gun",
									value = false,
									tooltip = "Makes it so that your weapon does not\nsway due to mouse movement, or turns over while sprinting.",
								},
							},
						},
						{
							name = { "Extra", "Exploits" },
							autopos = "right",
							autofill = true,
							[1] = {
								content = {
									{
										type = TOGGLE,
										name = "Ignore Friends",
										value = true,
										tooltip = "When turned on, bullets do not deal damage to friends,\nand Rage modules won't target friends.",
									},
									{
										type = TOGGLE,
										name = "Target Only Priority Players",
										value = false,
										tooltip = "When turned on, all modules except for Aim Assist that target players\nwill ignore anybody that isn't on the Priority list.",
									},
									{
										type = TOGGLE,
										name = "Disable 3D Rendering",
										value = false,
										tooltip = "When turned on, all 3D rendering will be disabled.\nThis helps with running multiple instances at once."
									},
									{
										type = TOGGLE,
										name = "Suppress Only",
										value = false,
										tooltip = "When turned on, bullets do not deal damage.",
									},
									{
										type = TOGGLE,
										name = "Auto Respawn",
										value = false,
										tooltip = "Automatically respawns after deaths.",
									},
									-- {
									-- 	type = TOGGLE,
									-- 	name = "Disable Team Sounds",
									-- 	value = false,
									-- 	tooltip = "Disables sounds from all teammates and local player.",
									-- },
									{
										type = DROPBOX,
										name = "Vote Friends",
										value = 1,
										values = { "Off", "Yes", "No" },
									},
									{
										type = DROPBOX,
										name = "Vote Priority",
										value = 1,
										values = { "Off", "Yes", "No" },
									},
									{
										type = DROPBOX,
										name = "Default Vote",
										value = 1,
										values = { "Off", "Yes", "No" },
									},
									{
										type = TOGGLE,
										name = "Kill Sound",
										value = false,
									},
									{
										type = TEXTBOX,
										name = "killsoundid",
										text = "6229978482",
										tooltip = "The Roblox sound ID or file inside of synapse\n workspace to play when Kill Sound is on.",
									},
									{
										type = SLIDER,
										name = "Kill Sound Volume",
										value = 20,
										minvalue = 0,
										maxvalue = 100,
										stradd = "%",
									},
									{
										type = TOGGLE,
										name = "Kill Say",
										value = false,
										tooltip = "Kill say messages, located in bitchbot/killsay.txt \n[name] is the target's name\n[weapon] is the weapon used\n[hitbox] says head or body depending on where you shot the player",
									},
									{
										type = DROPBOX,
										name = "Chat Spam",
										value = 1,
										values = {
											"Off",
											"Original",
											"t0nymode",
											"Chinese Propaganda",
											"Emojis",
											"Deluxe",
											"Youtube Title",
											"Custom",
											"Custom Combination",
										},
										tooltip = "Spams chat, Custom options are located in the bitchbot/chatspam.txt",
									},
									{
										type = TOGGLE,
										name = "Chat Spam Repeat",
										value = false,
										tooltip = "Repeats the same Chat Spam message in chat.",
									},
									{
										type = SLIDER,
										name = "Chat Spam Delay",
										minvalue = 1,
										maxvalue = 10,
										value = 5,
										stradd = " seconds",
									},
									{
										type = TOGGLE,
										name = "Auto Martyrdom",
										value = false,
										tooltip = "Whenever you die to an enemy, this will drop a grenade\nat your death position.",
									},
									{
										type = TOGGLE,
										name = "Break Windows",
										value = false,
										tooltip = "Breaks all windows in the map when you spawn."
									},
									{
										type = TOGGLE,
										name = "Join New Game On Kick",
										value = false,
									},
									{
										type = BUTTON,
										name = "Join New Game",
										unsafe = false,
										doubleclick = true,
									},

								},
							},
							[2] = {
								content = {

									--[[{
										type = TOGGLE,
										name = "Super Invisibility",
										value = false,
										extra = {
											type = KEYBIND
										}
									},]]
									{
										type = TOGGLE,
										unsafe = true,
										name = "Crash Server",
										tooltip = "Attempts to overwhelm the server so that users are kicked\nfor internet connection problems.\nThe higher the Crash Intensity the faster it will be,\nbut the higher the chance for it to fail.",
									},
									{
										type = SLIDER, 
										name = "Crash Intensity",
										minvalue = 1, 
										maxvalue = 16,
										value = 8
									},
									-- {
									-- 	type = TOGGLE,
									-- 	unsafe = true,
									-- 	name = "Invisibility",
									-- 	extra = {
									-- 		type = KEYBIND,
									-- 		toggletype = 0,
									-- 	},
									-- },
									{
										type = TOGGLE,
										unsafe = true,
										name = "Rapid Kill",
										value = false,
										extra = {
											type = KEYBIND,
											toggletype = 0,
										},
										tooltip = "Throws 3 grenades instantly on random enemies.",
									},
									{
										type = TOGGLE,
										unsafe = true,
										name = "Auto Rapid Kill",
										value = false,
										tooltip = "Throws 3 grenades instantly on random enemies,\nthen respawns to do it again.\nWorks only when Rapid Kill is enabled.",
									},
									{
										type = TOGGLE,
										unsafe = true,
										name = "Grenade Teleport",
										value = false,
										tooltip = "Sets any spawned grenade's position to the nearest enemy to your cursor and instantly explodes.",
									},
									{
										type = TOGGLE,
										unsafe = true,
										name = "Crimwalk",
										value = false,
										extra = {
											type = KEYBIND,
										},
									},
									{
										type = TOGGLE,
										name = "Disable Crimwalk on Shot",
										value = true,
										unsafe = true,
									},
									{
										type = TOGGLE,
										name = "Bypass Speed Checks",
										value = false,
										unsafe = true,
										tooltip = "Attempts to bypass maximum speed limit on the server.",
									},
									{
										type = TOGGLE,
										name = "Teleport",
										value = false,
										unsafe = true,
										extra = {
											type = KEYBIND,
											toggletype = 0,
										},
										tooltip = "When key pressed you will teleport to the mouse position.\nDoes not work when Bypass Speed Checks is enabled.",
									},
									{
										type = TOGGLE,
										name = "Vertical Floor Clip",
										value = false,
										unsafe = true,
										extra = {
											type = KEYBIND,
											toggletype = 0,
										},
										tooltip = "Teleports you 19 studs under the ground. Must be over glass or non-collidable parts to work. \nHold Alt to go up, and Shift to go forwards.",
									},
									{
										type = TOGGLE,
										name = "Fake Equip",
										value = false,
										unsafe = true,
									},
									{
										type = DROPBOX,
										name = "Fake Slot",
										values = { "Primary", "Secondary", "Melee" },
										value = 1,
									},

									-- {
									-- 	type = TOGGLE,
									-- 	name = "Noclip",
									-- 	value = false,
									-- 	extra = {
									-- 		type = KEYBIND,
									-- 		key = nil
									-- 	},
									-- 	unsafe = true,
									-- 	tooltip = "Allows you to noclip through most parts of the map. Must be over glass or non-collidable parts to work."
									-- },
									-- {
									-- 	type = TOGGLE,
									-- 	name = "Fake Position",
									-- 	value = false,
									-- 	extra = {
									-- 		type = KEYBIND
									-- 	},
									-- 	unsafe = true,
									-- 	tooltip = "Fakes your server-side position. Works best when stationary, and allows you to be unhittable."
									-- },
									{
										type = TOGGLE,
										name = "Lock Player Positions",
										value = false,
										unsafe = true,
										extra = {
											type = KEYBIND,
										},
										tooltip = "Locks all other players' positions.",
									},
									-- {
									-- 	type = TOGGLE,
									-- 	name = "Skin Changer",
									-- 	value = false,
									-- 	tooltip = "While this is enabled, all custom skins will apply with the custom settings below.",
									-- 	extra = {
									-- 		type = COLORPICKER,
									-- 		name = "Weapon Skin Color",
									-- 		color = { 127, 72, 163, 255 },
									-- 	},
									-- },
									-- {
									-- 	type = TEXTBOX,
									-- 	name = "skinchangerTexture",
									-- 	text = "6156783684",
									-- },
									-- {
									-- 	type = SLIDER,
									-- 	name = "Scale X",
									-- 	value = 10,
									-- 	minvalue = 1,
									-- 	maxvalue = 500,
									-- 	stradd = "%",
									-- },
									-- {
									-- 	type = SLIDER,
									-- 	name = "Scale Y",
									-- 	value = 10,
									-- 	minvalue = 1,
									-- 	maxvalue = 500,
									-- 	stradd = "%",
									-- },
									-- {
									-- 	type = DROPBOX,
									-- 	name = "Skin Material",
									-- 	value = 1,
									-- 	values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
									-- },
								},
							},
						},
					},
				},
				{
					name = "Settings",
					content = {
						{
							name = "Player List",
							x = menu.columns.left,
							y = 66,
							width = menuWidth - 34,
							height = 328,
							content = {
								{
									type = "list",
									name = "Players",
									multiname = { "Name", "Team", "Status" },
									size = 9,
									columns = 3,
								},
								{
									type = IMAGE,
									name = "Player Info",
									text = "No Player Selected",
									size = 72,
								},
								{
									type = DROPBOX,
									name = "Player Status",
									x = 307,
									y = 314,
									w = 160,
									value = 1,
									values = { "None", "Friend", "Priority" },
								},
								{
									type = BUTTON,
									name = "Votekick",
									doubleclick = true,
									x = 307,
									y = 356,
									w = 76,
								},
								{
									type = BUTTON,
									name = "Spectate",
									x = 391,
									y = 356,
									w = 76,
								},
							},
						},
						{
							name = "Cheat Settings",
							x = menu.columns.left,
							y = 400,
							width = menu.columns.width,
							height = 182,
							content = {
								{
									type = TOGGLE,
									name = "Menu Accent",
									value = false,
									extra = {
										type = COLORPICKER,
										name = "Accent Color",
										color = { 127, 72, 163 },
									},
								},
								{
									type = TOGGLE,
									name = "Watermark",
									value = true,
								},
								{
									type = TOGGLE,
									name = "Custom Menu Name",
									value = MenuName and true or false,
								},
								{
									type = TEXTBOX,
									name = "MenuName",
									text = MenuName or "Bitch Bot",
								},
								{
									type = BUTTON,
									name = "Set Clipboard Game ID",
								},
								{
									type = BUTTON,
									name = "Unload Cheat",
									doubleclick = true,
								},
								{
									type = TOGGLE,
									name = "Allow Unsafe Features",
									value = false,
								},
							},
						},
						{
							name = "Configuration",
							x = menu.columns.right,
							y = 400,
							width = menu.columns.width,
							height = 182,
							content = {
								{
									type = TEXTBOX,
									name = "ConfigName",
									file = true,
									text = "",
								},
								{
									type = DROPBOX,
									name = "Configs",
									value = 1,
									values = GetConfigs(),
								},
								{
									type = BUTTON,
									name = "Load Config",
									doubleclick = true,
								},
								{
									type = BUTTON,
									name = "Save Config",
									doubleclick = true,
								},
								{
									type = BUTTON,
									name = "Delete Config",
									doubleclick = true,
								},
							},
						},
					},
				},
			})

			do
				local plistinfo = menu.options["Settings"]["Player List"]["Player Info"][1]
				local plist = menu.options["Settings"]["Player List"]["Players"]
				local function updateplist()
					if not menu then
						return
					end
					local playerlistval = menu:GetVal("Settings", "Player List", "Players")
					local players = table.create(Players.MaxPlayers)

					for i, team in pairs(TEAMS:GetTeams()) do
						local sorted_players = table.create(#players)
						for i1, player in pairs(team:GetPlayers()) do
							table.insert(sorted_players, player.Name)
						end
						table.sort(sorted_players) -- why the fuck doesn't this shit work ...
						for i1, player_name in pairs(sorted_players) do
							table.insert(players, Players:FindFirstChild(player_name))
						end
					end
					local templist = table.create(#players)
					for k, v in ipairs(players) do
						local plyrname = { v.Name, RGB(255, 255, 255) }
						local teamtext = { "None", RGB(255, 255, 255) }
						local plyrstatus = { "None", RGB(255, 255, 255) }
						if v.Team ~= nil then
							teamtext[1] = v.Team.Name
							teamtext[2] = v.TeamColor.Color
						end
						if v == LOCAL_PLAYER then
							plyrstatus[1] = "Local Player"
							plyrstatus[2] = RGB(66, 135, 245)
						elseif table.find(menu.friends, v.Name) then
							plyrstatus[1] = "Friend"
							plyrstatus[2] = RGB(0, 255, 0)
						elseif table.find(menu.priority, v.Name) then
							plyrstatus[1] = "Priority"
							plyrstatus[2] = RGB(255, 210, 0)
						end

						table.insert(templist, { plyrname, teamtext, plyrstatus })
					end
					plist[5] = templist
					if playerlistval ~= nil then
						for i, v in ipairs(players) do
							if v.Name == playerlistval then
								selectedPlayer = v
								break
							end
							if i == #players then
								selectedPlayer = nil
								menu.list.setval(plist, nil)
							end
						end
					end
					menu:SetMenuPos(menu.x, menu.y)
				end

				local function setplistinfo(player, textonly)
					if player ~= nil then
						local playerteam = "None"
						if player.Team ~= nil then
							playerteam = player.Team.Name
						end
						local playerhealth = "?"

						local alive = client.hud:isplayeralive(player)
						if alive then
							playerhealth = math.ceil(client.hud:getplayerhealth(player))
						else
							playerhealth = "Dead"
						end
						local playerdata = teamdata[1]:FindFirstChild(player.Name) or teamdata[2]:FindFirstChild(player.Name)
						local playerrank = playerdata.Rank.Text
						local kills = playerdata.Kills.Text
						local deaths = playerdata.Deaths.Text
						plistinfo[1].Text = string.format(
							[[
Name: %s
Health: %s
Rank: %d
K/D: %d/%d
				]],
							player.Name,
							tostring(playerhealth),
							playerrank,
							kills,
							deaths
						)
						if textonly == nil then
							plistinfo[2].Data = BBOT_IMAGES[5]

							plistinfo[2].Data = game:HttpGet(string.format(
								"https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=100&height=100&format=png",
								player.UserId
							))
						end
					else
						plistinfo[2].Data = BBOT_IMAGES[5]
						plistinfo[1].Text = "No Player Selected"
					end
				end

				menu.list.removeall(menu.options["Settings"]["Player List"]["Players"])
				updateplist()
				setplistinfo()

				local oldslectedplyr = nil
				menu.connections.inputstart2 = INPUT_SERVICE.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if menu.tabnames[menu.activetab] == "Settings" and menu.open then
							game.RunService.Stepped:wait()

							updateplist()

							if selectedPlayer ~= nil then
								if menu:MouseInMenu(28, 68, 448, 238) then
									if table.find(menu.friends, selectedPlayer.Name) then
										menu.options["Settings"]["Player List"]["Player Status"][1] = 2
										menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "Friend"
									elseif table.find(menu.priority, selectedPlayer.Name) then
										menu.options["Settings"]["Player List"]["Player Status"][1] = 3
										menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "Priority"
									else
										menu.options["Settings"]["Player List"]["Player Status"][1] = 1
										menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "None"
									end
								end

								for k, table_ in pairs({ menu.friends, menu.priority }) do
									for index, plyrname in pairs(table_) do
										if selectedPlayer.Name == plyrname then
											table.remove(table_, index)
										end
									end
								end
								if menu:GetVal("Settings", "Player List", "Player Status") == 2 then
									if not table.find(menu.friends, selectedPlayer.Name) then
										table.insert(menu.friends, selectedPlayer.Name)
										WriteRelations()
									end
								elseif menu:GetVal("Settings", "Player List", "Player Status") == 3 then
									if not table.find(menu.priority, selectedPlayer.Name) then
										table.insert(menu.priority, selectedPlayer.Name)
										WriteRelations()
									end
								end
							else
								menu.options["Settings"]["Player List"]["Player Status"][1] = 1
								menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "None"
							end

							updateplist()

							if plist[1] ~= nil then
								if oldslectedplyr ~= selectedPlayer then
									setplistinfo(selectedPlayer)
									oldslectedplyr = selectedPlayer
								end
							else
								setplistinfo(nil)
							end
						end
					end
				end)

				menu.connections.renderstepped2 = game.RunService.RenderStepped:Connect(function()
					if menu.open then
						if menu.tabnames[menu.activetab] == "Settings" then
							if plist[1] ~= nil then
								setplistinfo(selectedPlayer, true)
							end
						end
					end
				end)

				menu.connections.playerjoined = Players.PlayerAdded:Connect(function(player)
					updateplist()
					if plist[1] ~= nil then
						setplistinfo(selectedPlayer)
					else
						setplistinfo(nil)
					end
				end)

				menu.connections.playerleft = Players.PlayerRemoving:Connect(function(player)
					updateplist()
					ragebot.repupdates[player] = nil
				end)
			end
		end --!SECTION PF END
	end
end

do
	local wm = menu.watermark
	wm.textString = " | " .. BBOT.username .. " | " .. os.date("%b. %d, %Y")
	wm.pos = Vector2.new(50, 9)
	wm.text = {}
	local fulltext = menu.options["Settings"]["Cheat Settings"]["MenuName"][1] .. wm.textString
	wm.width = #fulltext * 7 + 10
	wm.height = 19
	wm.rect = {}

	Draw:FilledRect(
		false,
		wm.pos.x,
		wm.pos.y + 1,
		wm.width,
		2,
		{ menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40, 255 },
		wm.rect
	)
	Draw:FilledRect(false, wm.pos.x, wm.pos.y, wm.width, 2, { menu.mc[1], menu.mc[2], menu.mc[3], 255 }, wm.rect)
	Draw:FilledRect(false, wm.pos.x, wm.pos.y + 3, wm.width, wm.height - 5, { 50, 50, 50, 255 }, wm.rect)
	for i = 0, wm.height - 4 do
		Draw:FilledRect(
			false,
			wm.pos.x,
			wm.pos.y + 3 + i,
			wm.width,
			1,
			{ 50 - i * 1.7, 50 - i * 1.7, 50 - i * 1.7, 255 },
			wm.rect
		)
	end
	Draw:OutlinedRect(false, wm.pos.x, wm.pos.y, wm.width, wm.height, { 0, 0, 0, 255 }, wm.rect)
	Draw:OutlinedRect(false, wm.pos.x - 1, wm.pos.y - 1, wm.width + 2, wm.height + 2, { 0, 0, 0, 255 * 0.4 }, wm.rect)
	Draw:OutlinedText(
		fulltext,
		2,
		false,
		wm.pos.x + 5,
		wm.pos.y + 3,
		13,
		false,
		{ 255, 255, 255, 255 },
		{ 0, 0, 0, 255 },
		wm.text
	)
end

--ANCHOR watermak
for k, v in pairs(menu.watermark.rect) do
	v.Visible = true
end
menu.watermark.text[1].Visible = true

local textbox = menu.options["Settings"]["Configuration"]["ConfigName"]
local relconfigs = GetConfigs()
textbox[1] = relconfigs[menu.options["Settings"]["Configuration"]["Configs"][1]]
textbox[4].Text = textbox[1]

menu.load_time = math.floor((tick() - loadstart) * 1000)
CreateNotification(string.format("Done loading the " .. menu.game .. " cheat. (%d ms)", menu.load_time))
CreateNotification("Press DELETE to open and close the menu!")
CreateThread(function()
	local x = loadingthing.Position.x
	for i = 1, 20 do
		loadingthing.Transparency = 1-i/20
		loadingthing.Position -= Vector2.new(x/10, 0)
		wait()
	end
	loadingthing.Visible = false -- i do it this way because otherwise it would fuck up the Draw:UnRender function, it doesnt cause any lag sooooo
end)
if not menu.open then
	menu.fading = true
	menu.fadestart = tick()
end

menu.Initialize = nil -- let me freeeeee
-- not lettin u free asshole bitch
-- i meant the program memory, alan...............  fuckyouAlan_iHateYOU from v1
-- im changing all the var names that had typos by me back to what they were now because of this.... enjoy hieght....
-- wut
_G.CreateNotification = CreateNotification