import json
import asyncio
from aiogram import Bot, Dispatcher, F
from aiogram.types import LabeledPrice, PreCheckoutQuery, Message, ContentType
from aiogram.filters import CommandStart
from aiogram.enums import ParseMode

# ====================== НАСТРОЙКИ ======================
BOT_TOKEN = "9117127405:AAHCnHBXS-JGJ9pxaGVEBvdh-tP0Um5tI2I"
VPN_KEY = "https://s-25329.us10.h1clayd.click/sub/98604921-7205-41cd-ba88-ab400711e340"
# =======================================================

bot = Bot(token=BOT_TOKEN)
dp = Dispatcher()

@dp.message(F.content_type == ContentType.WEB_APP_DATA)
async def web_app_data(message: Message):
    try:
        data = json.loads(message.web_app_data.data)
    except:
        return await message.answer("Ошибка данных")

    if data.get("action") != "buy":
        return

    stars = int(data.get("stars", 60))
    plan = data.get("plan", "3 месяца")
    days = int(data.get("days", 90))

    prices = [LabeledPrice(label=f"Gloat Vpn — {plan}", amount=stars)]

    await bot.send_invoice(
        chat_id=message.chat.id,
        title=f"Gloat Vpn — {plan}",
        description=f"Доступ на {plan}\nРаботает в Happ, v2RayTun, Incy",
        payload=f"gloat_{days}_{message.from_user.id}",
        provider_token="",
        currency="XTR",
        prices=prices
    )

@dp.pre_checkout_query()
async def pre_checkout(query: PreCheckoutQuery):
    await query.answer(ok=True)

@dp.message(F.content_type == ContentType.SUCCESSFUL_PAYMENT)
async def successful_payment(message: Message):
    await message.answer(
        f"✅ <b>Оплата прошла успешно!</b>\n\n"
        f"Твой ключ доступа:\n"
        f"<code>{VPN_KEY}</code>\n\n"
        f"Вставь эту ссылку в <b>Happ</b> / <b>v2RayTun</b> / <b>Incy</b> как подписку.",
        parse_mode=ParseMode.HTML
    )

@dp.message(CommandStart())
async def start(message: Message):
    await message.answer(
        "Добро пожаловать в <b>Gloat Vpn</b>!\n\n"
        "Нажми кнопку меню слева внизу, чтобы открыть приложение и купить доступ.",
        parse_mode=ParseMode.HTML
    )

async def main():
    print("Бот запущен...")
    await dp.start_polling(bot)

if __name__ == "__main__":
    asyncio.run(main())
